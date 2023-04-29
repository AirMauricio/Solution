import app

def run():
    file_departamentos = './transform_PDF_CSV/csv_tables/departamentos.csv'
    app.load_data_departamentos(file_departamentos)

if __name__ == '__main__':
    run()