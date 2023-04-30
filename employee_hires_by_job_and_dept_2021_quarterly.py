# Importar las librerías necesarias
from flask import Flask
import mysql.connector
import configparser

# Crear la aplicación Flask
app = Flask(__name__)

# Leer la configuración de la base de datos desde el archivo 'config.ini'
config = configparser.ConfigParser()
config.read('config.ini')

# Establecer la conexión a la base de datos usando los datos de configuración
mydb = mysql.connector.connect(
                                user      = config['database']['USER'], 
                                password  = config['database']['PASSWORD'],
                                host      = config['database']['HOST'], 
                                database  = config['database']['DATABASE']
                            )

# Definir la ruta del endpoint '/employee_hires_by_job_and_dept_2021_quarterly' y su método GET
@app.route('/employee_hires_by_job_and_dept_2021_quarterly', methods=['GET'])
def employee_hires_by_job_and_dept_2021_quarterly():
    # Crear un cursor para la base de datos
    cursor = mydb.cursor()
    
    # Definir la consulta SQL para obtener los datos de la vista 'view_employee_hires_by_job_and_dept_2021_quarterly'
    query = """
                SELECT *
                FROM HR.view_employee_hires_by_job_and_dept_2021_quarterly
                ORDER BY department ASC, job ASC
            """
    # Ejecutar la consulta SQL
    cursor.execute(query)
    
    # Obtener los resultados de la consulta
    result = cursor.fetchall()

    # Crear la tabla HTML con los resultados de la consulta
    table = '<table><tr><th>Department</th><th>Job</th><th>Q1-21</th><th>Q2-21</th><th>Q3-21</th><th>Q4-21</th></tr>'
    for row in result:
        table += f"<tr><td>{row[0]}</td><td>{row[1]}</td><td>{row[2]}</td><td>{row[3]}</td><td>{row[4]}</td><td>{row[5]}</td></tr>"
    table += "</table>"

    # Devolver la tabla en HTML
    return table

# Iniciar la aplicación Flask en modo debug si se ejecuta este archivo directamente
if __name__ == '__main__':
    app.run(debug=True)