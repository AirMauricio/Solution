# Importar las librerías necesarias
from flask import Flask, jsonify
import pandas as pd
import pymysql
import numpy as np
import configparser

# Crear una instancia de Flask
app = Flask(__name__)

# Definir la ruta de la API
@app.route('/load_data', methods=['GET'])
def load_data():
    # Leer los datos de los archivos CSV con pandas
    files = ['transform_PDF_CSV/csv_tables/departamentos.csv', 'transform_PDF_CSV/csv_tables/jobs.csv', 'transform_PDF_CSV/csv_tables/hired.csv']
    tables = ['departments_origen', 'jobs_origen', 'hired_employees_origen']
    num_inserted = [0, 0, 0]  # contador para cada tabla
    
    for i, file in enumerate(files):
        data = pd.read_csv(file, sep=";")
        table = tables[i]

        # Conectar con la base de datos MySQL
        config = configparser.ConfigParser()
        config.read('config.ini')

        conn = pymysql.connect(
                                
                                user      = config['database']['USER'], 
                                password  = config['database']['PASSWORD'],
                                host      = config['database']['HOST'], 
                                database  = config['database']['DATABASE']
                            )

        cursor = conn.cursor()

        # Insertar los datos en la tabla correspondiente
        try:
            if table == 'departments_origen':
                # Validar valores NaN
                data = data.replace({np.nan: None})                
                for j, row in data.iterrows():
                    query = "INSERT INTO departments_origen (id, department) VALUES (%s, %s)"
                    params = (row['id'], row['department'])
                    cursor.execute(query, params)
                    num_inserted[i] += 1  # incrementar contador
                conn.commit()

            elif table == 'jobs_origen':
                # Validar valores NaN
                data = data.replace({np.nan: None})                
                for j, row in data.iterrows():
                    query = "INSERT INTO jobs_origen (id, job) VALUES (%s, %s)"
                    params = (row['id'], row['job'])
                    cursor.execute(query, params)
                    num_inserted[i] += 1  # incrementar contador
                conn.commit()

            elif table == 'hired_employees_origen':
                # Validar valores NaN
                data = data.replace({np.nan: None})
                for j, row in data.iterrows():
                    query = "INSERT INTO hired_employees_origen (id, name, datetime, department_id, job_id) VALUES (%s, %s, %s, %s, %s)"
                    params = (row['id'], row['name'], row['datetime'], row['department_id'], row['job_id'])
                    cursor.execute(query, params)
                    num_inserted[i] += 1  # incrementar contador
                conn.commit()

        except Exception as e:
            print(f"Error: {e}")
            conn.rollback()

        # Cerrar la conexión con la base de datos
        cursor.close()
        conn.close()

    # Devolver una respuesta JSON con los datos insertados
    message = f"Se insertaron {num_inserted[0]} datos en la tabla departments_origen, {num_inserted[1]} datos en la tabla jobs_origen, y {num_inserted[2]} datos en la tabla hired_employees_origen."
    return jsonify({'message': message})

# Iniciar la aplicación en modo debug
if __name__ == '__main__':
    app.run(debug=True) 