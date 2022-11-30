import os
import csv
import tempfile
import mariadb
import sys
from dotenv import load_dotenv
from fuzzywuzzy import process, fuzz

sys.path.append(
    ""
)
from bolsar_scrapper import *

load_dotenv()
DB_HOST = os.getenv("DB_HOST")
DB_PORT = os.getenv("DB_PORT")
DB_DATABASE = os.getenv("DB_DATABASE")
DB_USERNAME = os.getenv("DB_USERNAME")
DB_PASSWORD = os.getenv("DB_PASSWORD")

CUITS_DB = ""
DIRECTORY = ""
STOCKS_INFORMATION_FILES = ("acciones_lideres.csv", "panel_general.csv")
BOND_INFORMATION_FILE = "bonos_públicos.csv"
NEGOTIATED_AMOUNTS_FILE = "montos_negociados.csv"


def database_connection(user, password, host, port, database):
    try:
        db = mariadb.connect(
            user=user,
            password=password,
            host=host,
            port=int(port),
            database=database,
        )
    except mariadb.Error as e:
        print(f"Error connecting to MariaDB Platform: {e}")
        sys.exit(1)

    return db


def get_csv_information(directory, csv_files):
    csv_info = []
    for csv_file in csv_files:
        with open(
            os.path.join(directory, csv_file), "r", encoding="utf-8"
        ) as file:
            reader = csv.reader(file)
            next(reader)
            for row in reader:
                csv_info.append(row)

    return csv_info


def get_db_stocks_name(cur):
    cur.execute("SELECT especie FROM acciones")
    db_stocks = set(cur)
    if db_stocks:
        db_stocks = set(next(zip(*db_stocks)))

    return db_stocks


def get_stocks_data(stocks):
    stocks_data = []

    with tempfile.TemporaryDirectory() as temp_directory:
        try:
            browser = create_browser(temp_directory)
            for stock in stocks:
                stock_data = get_stock_data(browser, stock)
                if stock_data[0] != "":
                    stocks_data.append([stock_data[0], stock, stock_data[1]])
        finally:
            if browser:
                browser.close()

    return stocks_data


def get_name_and_cuit(csv_db):
    names = []
    cuits = []
    with open(csv_db, "r", encoding="utf-8") as csv_file:
        reader = csv.reader(csv_file)
        next(reader)
        for row in reader:
            if row[0] and int(row[0]) < 31000000000 and row[3] == "SOCIEDAD ANONIMA":
                cuits.append(row[0])
                names.append(row[1])

    return names, cuits


def get_cuit(company, companies_names, companies_cuits):
    search = process.extract(query=company, choices=companies_names, limit=1, scorer=fuzz.ratio)
    return companies_cuits[companies_names.index(search[0][0])]


def append_cuit_to_data(stocks_data, companies_names, companies_cuits):
    updated_stocks_data = []
    for stock in stocks_data:
        if stock[0]:
            updated_stocks_data.append(
                [get_cuit(stock[0], companies_names, companies_cuits), *stock]
            )

    return updated_stocks_data


def add_companies_to_db(cur, data):
    try:
        cur.executemany("INSERT INTO empresas VALUES (?, ?)", data)
    except mariadb.Error as e:
        print(e)


def add_stocks_to_db(cur, data):
    try:
        cur.executemany("INSERT INTO acciones VALUES (?, ?, ?)", data)
    except mariadb.Error as e:
        print(e)


def add_trds_to_db(cur, data):
    try:
        cur.executemany("INSERT INTO TRDs VALUES (?)", data)
    except mariadb.Error as e:
        print(e)


def get_companies_data(stocks_data):
    companies_data = []
    for stock in stocks_data:
        companies_data.append(stock[0:2])
    return companies_data


def get_stock_data_to_insert(stocks_data):
    data_to_insert = []
    for stock in stocks_data:
        data_to_insert.append([stock[2], stock[0], stock[3]])
    return data_to_insert


def prepare_trds_for_insertion(trds):
    prepared_trds = []
    for trd in trds:
        prepared_trds.append([trd])
    return prepared_trds


def get_db_trds(cur):
    cur.execute("SELECT * FROM TRDs")
    db_trds = list(cur)
    
    return db_trds


db = database_connection(
    DB_USERNAME, DB_PASSWORD, DB_HOST, DB_PORT, DB_DATABASE
)
cur = db.cursor()
stocks_info = get_csv_information(DIRECTORY, STOCKS_INFORMATION_FILES)
bond_info = get_csv_information(DIRECTORY, (BOND_INFORMATION_FILE,))
negotiated_amounts_info = get_csv_information(
    DIRECTORY, (NEGOTIATED_AMOUNTS_FILE,)
)

try:
    db_stocks_name = get_db_stocks_name(cur)
except mariadb.Error as e:
    print(e)
    db.close()
    sys.exit(1)

obtained_stocks_name = set(next(zip(*stocks_info)))
absent_stocks = obtained_stocks_name.difference(db_stocks_name)
add_trds_to_db(cur, prepare_trds_for_insertion(absent_stocks))
stocks_data = get_stocks_data(absent_stocks)
companies_names, companies_cuits = get_name_and_cuit(CUITS_DB)
stocks_data = append_cuit_to_data(
    stocks_data, companies_names, companies_cuits
)

for stock in stocks_data:
    print(stock)

add_companies_to_db(cur, get_companies_data(stocks_data))
add_stocks_to_db(cur, get_stock_data_to_insert(stocks_data))

db.commit()
db.close()
