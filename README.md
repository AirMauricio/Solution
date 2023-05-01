# README

## Proyecto Python para carga de datos a MySQL y generación de reportes
Este proyecto consta de 4 fases para procesar archivos en formato PDF, convertirlos a CSV, cargarlos en una base de datos MySQL y generar reportes a través de un REST API.

## Dependencias

Para instalar las dependencias necesarias para ejecutar el proyecto, se debe utilizar el siguiente comando en la terminal:

```
git clone
sudo apt-get update
sudo apt install python3.10-venv
sudo apt-get install mysql-server
sudo systemctl status mysql
sudo systemctl start mysql
sudo systemctl enable mysql
python3 -m venv env
source env/bin/activate
pip install -r requirements.txt
```
---
## Ejecución del proyecto

### Fase 1: Transformación archivos y creación de base de datos.

Para ejecutar esta fase se deben seguir los siguientes pasos:
- Ubicar los archivos en formato .pdf en la carpeta “transform_PDF_CSV/pdf_tables”.
- Ejecutar el script “main.py” ubicado en la ruta: “transform_PDF_CSV/main.py” con el comando “python main.py”.
- Crear la base de datos en MySQL con el comando ```CREATE DATABASE HR```.
- Crear las tablas origen y limpias con los comandos indicados en el archivo “create_tables.sql” ubicado en la carpeta “sql_scripts”.
- Crea los procedimientos almacenados que se encuentran en el archivo "create_SP.sql" ubicado en la carpeta "sql_scripts", verifica que los procedimientos se hayan creado correctamente con el comando ```SHOW PROCEDURE STATUS WHERE db = 'HR';``` ejecutado en mysql.
- Crea las vistas que se encuentran en el archivo "create_views.sql" ubicado en la carpeta "sql_scripts".

### Fase 2: Cargue de la información por medio de un REST API.

Para ejecutar esta fase se deben seguir los siguientes pasos:
- Asegurarse que la base de datos MySQL se encuentre en línea con el comando “mysql.server start”.
- Ejecutar el script “load_data.py” con el comando “python load_data.py”.
- Acceder a la dirección web creada “/load_data” y esperar a que se cargue la información a las tablas origen.

### Fase 3: Limpieza de la información.

Para ejecutar esta fase se deben ejecutar los procedimientos almacenados indicados en el archivo “stored_procedures.sql” ubicado en la carpeta “sql_scripts”.

### Fase 4: Creación de los reportes en un end-point.

Para ejecutar esta fase se deben seguir los siguientes pasos:
- Ejecutar el módulo “employee_hires_by_job_and_dept_2021_quarterly.py” con el comando “python employee_hires_by_job_and_dept_2021_quarterly.py”.
- Acceder a la dirección web creada ```/employee_hires_by_job_and_dept_2021_quarterly``` para ver el reporte de empleados contratados por trimestre y departamento.
- Ejecutar el módulo “department_hires_above_mean_2021.py” con el comando “python department_hires_above_mean_2021.py”.
- Acceder a la dirección web creada ```/department_hires_above_mean_2021``` para ver el reporte de departamentos con contrataciones superiores al promedio del 2021.

---
## Contribuyendo

Si deseas contribuir al proyecto, puedes crear un pull request en Github o comunicarte con el autor a través del correo electrónico proporcionado en el archivo LICENSE.

## Autor

El autor de este proyecto es [Oscar Gama](https://github.com/AirMauricio).