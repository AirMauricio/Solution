# Especificamos la imagen base para nuestro contenedor
FROM python:3.8

# Definimos el directorio de trabajo dentro del contenedor
WORKDIR /solution

# Copiamos el archivo de requerimientos al directorio de trabajo
COPY requirements.txt /solution/requirements.txt

# Instalamos las dependencias necesarias en el contenedor
RUN pip install --no-cache-dir --upgrade -r /solution/requirements.txt

# Copiamos todos los archivos del directorio actual al directorio de trabajo dentro del contenedor
COPY . /solution

# Ejecutamos el comando para mantener el contenedor en ejecución
CMD bash -c "while true; do sleep 1; done"
