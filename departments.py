import mysql.connector
from flask import Flask, jsonify
import configparser

app = Flask(__name__)

# Configuración de conexión a la base de datos
config = configparser.ConfigParser()
config.read('config.ini')

cnx = mysql.connector.connect(user=config['database']['USER'], password=config['database']['PASSWORD'],
                              host=config['database']['HOST'], database=config['database']['DATABASE'])
cursor = cnx.cursor()

@app.route('/departamentos_contratados', methods=['GET'])
def departamentos_contratados():
    query = """
            SELECT td.department_id, td.department, count(1) hired
            FROM HR.tb_hired_employees the
                JOIN HR.tb_departments td
                    ON the.department_id = td.department_id
            GROUP BY td.department_id, td.department
            HAVING count(1) > (
                                SELECT AVG(contratos) AVG_CONTRATOS
                                FROM (
                                        SELECT the.department_id, count(1) contratos
                                        FROM HR.tb_hired_employees the  
                                        WHERE YEAR(the.datetime) = 2021
                                        AND the.department_id IS NOT NULL
                                        GROUP BY the.department_id
                                ) A
                            )
            ORDER BY 3 DESC;
            """
    cursor.execute(query)
    data = cursor.fetchall()
    
    # Crear la tabla con los resultados de la consulta
    table = "<table><tr><th>Department ID</th><th>Department</th><th>Hired</th></tr>"
    for row in data:
        table += "<tr>"
        for cell in row:
            table += f"<td>{cell}</td>"
        table += "</tr>"
    table += "</table>"
    
    # Devolver la tabla en HTML
    return table

if __name__ == '__main__':
    app.run(debug=True)
