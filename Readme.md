# ft_server

## Features


## Requirement
- Docker

## Usage
Clone this repository:
```shell
git clone https://github.com/sakku-14/ft_server
```

Build the image:
```shell
docker build -t <image-name> .
```

Create the container:
```shell
docker run -d -p 8080:80 -p 443:443 <image-name>
```

Open nginx top page:
```shell:Url
https://127.0.0.1/
```
Then click ***Advanced***. After that click ***Accept the Risk and Continue***. Finally you are welcome to nginx!

Open wordpress page:
```shell:Url
https://127.0.0.1/wordpress/
```

Open phpmyadmin page:
```shell:Url
https://127.0.0.1/phpmyadmin/
```

## Note

## Author
- Yuki Sakuma
