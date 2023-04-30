# Importación de librerías y módulos
from flask import Flask
import mysql.connector
import configparser

# Creación de la aplicación de Flask
app = Flask(__name__)

# Configuración de conexión a la base de datos a través de un archivo de configuración
config = configparser.ConfigParser()
config.read('config.ini')

# Establecimiento de la conexión con la base de datos MySQL
cnx = mysql.connector.connect(
                                user      = config['database']['USER'], 
                                password  = config['database']['PASSWORD'],
                                host      = config['database']['HOST'], 
                                database  = config['database']['DATABASE']
                            )
cursor = cnx.cursor()

# Definición de la ruta de la API
@app.route('/department_hires_above_mean_2021', methods=['GET'])
def department_hires_above_mean_2021():
    """
    Retorna una tabla HTML con los departamentos que han contratado por encima del promedio en el año 2021.
    """
    # Consulta SQL para obtener los departamentos que han contratado por encima del promedio en el año 2021
    query = """
        SELECT *
        FROM HR.view_department_hires_above_mean_2021
        ORDER BY hired DESC
    """
    # Ejecución de la consulta
    cursor.execute(query)
    # Recuperación de los resultados
    data = cursor.fetchall()
    
    # Creación de la tabla HTML con los resultados de la consulta
    table = "<table><tr><th>Department ID</th><th>Department</th><th>Hired</th></tr>"
    for row in data:
        table += "<tr>"
        for cell in row:
            table += f"<td>{cell}</td>"
        table += "</tr>"
    table += "</table>"
    
    # Devolución de la tabla HTML con los resultados de la consulta
    return table

# Ejecución de la aplicación Flask
if __name__ == '__main__':
    app.run(debug=True)