from flask import Flask, jsonify
import pandas as pd
import pymysql

app = Flask(__name__)

@app.route('/load_data')
def load_data():
    # Leer los datos del archivo CSV con pandas
    data = pd.read_csv('transform_PDF_CSV/csv_tables/departamentos/departamentos.csv', sep=";")

    # Conectar con la base de datos MySQL
    conn = pymysql.connect(host='localhost',
                           user='root',
                           password='',
                           db='HR')
    cursor = conn.cursor()

    # Insertar los datos en la tabla de la base de datos
    for i, row in data.iterrows():
        query = f"INSERT INTO HR.departments (id, department) VALUES ('{row['id']}', '{row['department']}')"
        cursor.execute(query)
    conn.commit()

    # Cerrar la conexión con la base de datos
    cursor.close()
    conn.close()

    # Devolver una respuesta JSON con los datos insertados
    return jsonify({'message': 'Los datos han sido cargados correctamente'})

if __name__ == '__main__':
    app.run(debug=True)
