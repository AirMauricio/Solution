from flask import Flask, jsonify
import pandas as pd
import pymysql
import configparser

app = Flask(__name__)

@app.route('/load_data')
def load_data():
    # Leer los datos del archivo CSV con pandas
    data = pd.read_csv('transform_PDF_CSV/csv_tables/departamentos/departamentos.csv', sep=";")

    # Conectar con la base de datos MySQL
    config = configparser.ConfigParser()
    config.read('config.ini')


    conn = pymysql.connect(host     = config.get('database', 'host'),
                           user     = config.get('database', 'user'),
                           password = config.get('database', 'password'),
                           db       = config.get('database', 'database')
                           )
    cursor = conn.cursor()

    # Insertar los datos en la tabla de la base de datos
    try:
        for i, row in data.iterrows():
            query = "INSERT INTO HR.departments (id, department) VALUES (%s, %s)"
            params = (row['id'], row['department'])
            cursor.execute(query, params)
        conn.commit()

    except Exception as e:
        print(f"Error: {e}")
        conn.rollback()
    
    finally:
        # Cerrar la conexión con la base de datos
        cursor.close()
        conn.close()

    # Devolver una respuesta JSON con los datos insertados
    return jsonify({'message': 'Los datos han sido cargados correctamente'})

if __name__ == '__main__':
    app.run(debug=True)

