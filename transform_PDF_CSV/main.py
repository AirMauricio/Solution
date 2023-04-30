import os
import tabula

def run():
    # Carpeta que contiene los archivos PDF
    pdf_folder = './pdf_tables'

    # Carpeta de destino para los archivos CSV
    csv_folder = './csv_tables'

    # Recorrer todos los archivos en la carpeta
    for filename in os.listdir(pdf_folder):
        # Comprobar si el archivo es un PDF
        if filename.endswith('.pdf'):
            # Ruta completa del archivo PDF
            pdf_file = os.path.join(pdf_folder, filename)
            # Nombre del archivo CSV resultante
            csv_name = os.path.splitext(filename)[0] + '.csv'
            # Ruta completa del archivo CSV resultante
            csv_file = os.path.join(csv_folder, csv_name)
            # Convertir el archivo PDF a CSV y guardar en la carpeta de destino
            tabula.convert_into(pdf_file, csv_file, output_format='csv', pages='all')

if __name__ == "__main__":
    run()