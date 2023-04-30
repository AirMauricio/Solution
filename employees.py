from flask import Flask
from flask import render_template
import mysql.connector
import configparser

app = Flask(__name__)

config = configparser.ConfigParser()
config.read('config.ini')

mydb = mysql.connector.connect(
  host=config['database']['host'],
  user=config['database']['user'],
  password=config['database']['password'],
  database=config['database']['database']
)

@app.route('/consultadb')
def index():
    cursor = mydb.cursor()
    query = """
        SELECT department, job, 
               SUM(CASE WHEN Q = 'Q1-21' THEN 1 ELSE 0 END) AS 'Q1-21',
               SUM(CASE WHEN Q = 'Q2-21' THEN 1 ELSE 0 END) AS 'Q2-21',
               SUM(CASE WHEN Q = 'Q3-21' THEN 1 ELSE 0 END) AS 'Q3-21',
               SUM(CASE WHEN Q = 'Q4-21' THEN 1 ELSE 0 END) AS 'Q4-21'
        FROM (
                  SELECT    td.department, tj.job, 
                            CASE
                              WHEN MONTH(the.datetime) IN (1,2,3) THEN CONCAT('Q1-', RIGHT(YEAR(the.datetime),2))
                              WHEN MONTH(the.datetime) IN (4,5,6) THEN CONCAT('Q2-', RIGHT(YEAR(the.datetime),2))
                              WHEN MONTH(the.datetime) IN (7,8,9) THEN CONCAT('Q3-', RIGHT(YEAR(the.datetime),2))
                              WHEN MONTH(the.datetime) IN (10,11,12) THEN CONCAT('Q4-', RIGHT(YEAR(the.datetime),2))
                              ELSE NULL
                            END Q
                  FROM HR.tb_hired_employees the
                      INNER JOIN HR.tb_departments td 
                          ON the.department_id = td.department_id 
                      INNER JOIN HR.tb_jobs tj 
                          ON the.job_id  = tj.job_id 
                 WHERE YEAR(the.datetime) = 2021
        )t
        GROUP BY department, job
        ORDER BY department, job
    """
    cursor.execute(query)
    result = cursor.fetchall()

    table = '<!DOCTYPE html> <html> <head> <title>Tabla de empleados</title> <link rel="stylesheet" type="text/css" href="style.css"> </head> <body><table><tr><th>Department</th><th>Job</th><th>Q1-21</th><th>Q2-21</th><th>Q3-21</th><th>Q4-21</th></tr>'
    for row in result:
        table += f"<tr><td>{row[0]}</td><td>{row[1]}</td><td>{row[2]}</td><td>{row[3]}</td><td>{row[4]}</td><td>{row[5]}</td></tr>"
    table += "</table></body></html>"

    return table

if __name__ == '__main__':
    app.run(debug=True)
