-- HandsLab_01
drop database if exists HandsLabs;
-- Crear la base de datos HandsLabs, ponerla en uso y verificar en pantalla su existencia
create database HandsLabs;
use HandsLabs;

drop table if exists cliente;
-- Crear la tabla CLIENTE teniendo como referencia lo siguiente
create table cliente(
	id char(3) primary key,
    nombre varchar(120) not null,
    apellido varchar(160) not null,
    dni char(8) not null,
    email varchar(250),
    estado char(1) default 'A'
);

-- El campo código debe empezar con la letra C y dos dígitos numéricos.
alter table cliente add constraint idcli_valido check(id regexp '^[C][0-9][0-9]');
-- Los datos de DNI y Correo Electrónico deben ser valores únicos.
alter table cliente add constraint dnicli_unico unique(dni);
alter table cliente add constraint emacli_unico unique(email);
-- El campo DNI solamente debe aceptar 8 dígitos numéricos.
alter table cliente add constraint dnicli_valido check(dni regexp '^[0-9]{8}');
-- Se debe permitir el ingreso sólo de correos válidos.
alter table cliente add constraint emacli_valido check(email like '%_@%_._%');
-- Al momento de ingresar datos de clientes el estado es Activo (tenerlo presente en el borrado lógico)
alter table cliente add constraint estcli_valido check(estado = 'A' or estado = 'I');

insert into cliente (id, nombre, apellido, dni, email) values
('C01', 'Eugenio', 'Barrios Palomino', 78451211, 'eugenio@yahoo.com'),
('C02', 'Carolina', 'Tarazona Meza', 78451212, 'carolina,tarazona@yahoo.com'),
('C03', 'Roberto', 'Martínez Campos', 74125898, 'roberto.martinez@gmail.com'),
('C04', 'Claudia', 'Rodríguez Guerra', 15253698, 'claudia.rodriguez@outlook.com'),
('C05', 'Julio', 'Huaman Pérez', 45123698, 'julio.huaman@gmail.com'),
('C06', 'Marcos', 'Manco Ávila', 45781236, 'marcos.manco@yahoo.com'),
('C07', 'Micaela', 'Taipe Ormeño', 45127733, 'micaela.taipe@gmail.com'),
('C08', 'Pedro', 'Oré Vásquez', 15223364, 'pedro.ore@gmail.com'),
('C09', 'Yolanda', 'Palomino Farfán', 15223398, 'yolanda.palomino@autlook.com'),
('C10', 'Luisa', 'Sánchez Romero', 11223365, 'luisa.sanchez@gmail.com');

select id as 'Código', concat(upper(apellido),', ',nombre) as 'Cliente', dni as 'DNI', email as 'Email' from cliente;

drop table if exists empleado;
-- Crear la tabla EMPLEADO teniendo como referencia lo siguiente
create table empleado(
	id char(3) primary key,
    nombre varchar(120) not null,
    apellido varchar(160) not null,
    tipo char(1) not null,
    civil char(1) not null,
    email varchar(260),
    sexo char(1) not null,
    numh int,
    estado char(1) default 'A',
    pagh decimal(11,2)
);

-- El campo código, clave principal, debe empezar con la letra E y dos dígitos numéricos.
alter table empleado add constraint idemp_valido check(id regexp'^[E][0-9][0-9]');
-- El tipo de empleado es V (vendedor) y A (administrador), no existe otro tipo.
alter table empleado add constraint tipemp_valido check(tipo = 'V' or tipo = 'A');
-- El estado civil es S (soltero), C (casado) y  D (divorciado), no existe otro tipo.
alter table empleado add constraint civemp_valido check(civil = 'S' or civil = 'C' or civil = 'D');
-- Sólo se debe permitir correos únicos y válidos.
alter table empleado add constraint emaemp_unico unique(email);
alter table empleado add constraint emaemp_valido check(email like '%_@%_._%');
-- El sexo es M (masculino) y F (femenino)
alter table empleado add constraint sexemp_valido check(sexo = 'M' or sexo = 'F');
-- El número de horas de trabajo mensual máximo es 160.
alter table empleado add constraint nuhemp_valido check(numh <= 160);
-- El estado sólo debe permitir A (activo) e I (inactivo), no se admite otro tipo de estado.
alter table empleado add constraint estemp_valido check(estado = 'A' or estado = 'I');
-- El pago por hora es máximo de S/. 12.00
alter table empleado add constraint pahemp_valido check(pagh <= 12.00);

insert into empleado (id, nombre, apellido, tipo, civil, email, sexo, numh, pagh) values
('E01', 'Eulalio', 'MARTÍNEZ OCARES', 'V', 'S', 'eulalio.martinez@laempresa.com', 'M', 120, 11.00),
('E02', 'María', 'LOMBARDI GUERRA', 'V', 'C', 'maria.lombardi@laempresa.com', 'F', 110, 10.00),
('E03', 'Bruno', 'RODRÍGUEZ ROJAS', 'A', 'S', 'bruno.rodriguez@laempresa.com', 'M', 160, 12.00),
('E04', 'Benardo', 'PARRA GRAU', 'A', 'C', 'benardo.parra@laempresa.com', 'M', 160, 12.00),
('E05', 'Yolanda', 'BENAVIDES CENTENO', 'V', 'C', 'yolanda.benavides@laempresa.com', 'F', 100, 8.00),
('E06', 'Fabiana', 'OSCORIMA PEÑA', 'V', 'S', 'fabiana.oscorima@laempresa.com', 'F', 125, 8.00);

select id as 'Código', concat(upper(apellido),', ',nombre) as 'Empleado',
case when tipo = 'V' then 'Vendedor' when tipo = 'A' then 'Administrador' end as 'Tipo Empleado',
case when civil = 'S' then 'Soltero' when civil = 'C' then 'Casado' when civil = 'D' then 'Divorciado' end as 'Estado Civil',
email as 'Email', case when sexo = 'M' then 'Masculino' when sexo = 'F' then 'Femenino' end as 'Sexo',
numh as 'Num. Horas', case when estado = 'A' then 'Activo' when estado = 'I' then 'Inactivo' end as 'Estado',
concat('S/. ',pagh) as 'Pag. x hora' from empleado;

drop table if exists producto;
-- Crear la tabla PRODUCTO teniendo como referencia lo siguiente
create table producto(
	id char(3) primary key,
    nombre varchar(260) not null,
    marca text not null,
    color text,
-- El stock y precio no debe ser nulo y el valor por defecto es 0.
    stock int default 0,
    precio decimal(11,2) default 0,
    descripcion text,
    estado char(1) default 'A'
);

-- El campo código, clave principal, debe empezar con la letra P y dos dígitos numéricos.
alter table producto add constraint idpro_valido check(id regexp '^[P][0-9][0-9]');
-- El estado sólo permite A (activo) e I (inactivo) no se permite ninguna otra letra, por defecto es A.
alter table producto add constraint estpro_valido check(estado = 'A' or estado = 'I');

insert into producto (id, nombre, marca, color, stock, precio, descripcion) values
('P01', 'Combo inalámbrico de teclado y mouse', 'Logitech', 'Negro', '60', '32.75', 'Fácil de usar: este combo de teclado y mouse inalámbrico'),
('P02', 'Monitor LED ultradelgado sin marco', 'Sceptre', 'Negro y Rojo', '50', '120.42', 'Perfil ultra delgado de 24 pulgadas'),
('P03', 'Mouse inalámbrico para computador', 'Logitech', 'Negro', '75', '75.35', 'Comodidad hora tras hora con este mouse de diseño ergonómico'),
('P04', 'AMD Ryzen 7 5800X Procesador', 'AMD', '', '120', '245.88', 'AMD El procesador de 8 núcleos más rápido para escritorio principal'),
('P05', 'Lenovo IdeaPad Gaming 3 - 2022', 'Lenovo', 'Azul', '135', '599.99', 'Aumenta el rendimiento de tu juego con los procesadores AMD Ryzen serie 6000'),
('P06', 'TP-Link AC1750 - Enrutador WiFi', 'TP-Link', 'Negro', '92', '53.99', 'El enrutador de Internet inalámbrico funciona con Alexa, compatible con todos los dispositivos WiFi'),
('P07', 'Cámara web C920e HD 1080p', 'Logitech', 'Negro', '72', '66.99', 'La cámara web C920e cuenta con dos micrófonos omnidireccionales integrados'),
('P08', 'Estación de acoplamiento USB C', 'WAVLINK', 'Gris', '65', '55.87', 'Base USB C 12 en 1: Plug and Play');

select id as 'Codigo', nombre as 'Producto', marca as 'Marca', color as 'Color', stock as 'Stock', precio as 'Precio',
descripcion as 'Descripcion', case when estado = 'A' then 'Activo' when estado = 'I' then 'Inactivo' end as 'Estado' from producto;

drop table if exists venta;
-- Crear la tabla VENTA teniendo como referencia lo siguiente
create table venta(
-- El código de venta es auto incrementable de uno en uno.
	id int auto_increment primary key,
-- Se recoge la fecha del servidor de la base de datos al momento de registrar una venta.
    fecha date default current_timestamp(),
    idcli char(3) not null,
    idemp char(3) not null,
    tipago char(1) not null,
    estado char(1) default 'A',
-- Los Cliente y Empleados considerados en la Venta deben existir previamente en las tablas respectivas.
    foreign key(idcli) references cliente(id),
    foreign key(idemp) references empleado(id)
);

-- Los posibles tipos de pago son: E (efectivo), T (transferencia) y Y (yape).
alter table venta add constraint tipago_valido check(tipago = 'E' or tipago = 'T' or tipago = 'Y');
-- El estado sólo puede ser A (activo) e I (inactivo), no se acepta otro tipo de estado
alter table venta add constraint estven_valido check(estado = 'A' or estado = 'I');

insert into venta (idcli, idemp, tipago) values ('C03', 'E02', 'E'), ('C02', 'E04', 'T'), ('C05', 'E05', 'Y'), ('C08', 'E01', 'E');

select c.id as 'Codigo', date_format(v.fecha, '%d/%m/%y') as 'Fecha',
concat(upper(c.apellido),', ',c.nombre) as 'Cliente', concat(upper(e.apellido),', ',e.nombre) as 'Empleado',
case when v.tipago = 'E' then 'Efectivo' when v.tipago = 'T' then 'Transferencia' when v.tipago = 'Y' then 'Yape' end as 'Tipo Pago',
case when v.estado = 'A' then 'Activo' when v.estado = 'I' then 'Inactivo' end as 'Estado'
from venta v inner join cliente c on v.idcli = c.id inner join empleado e on v.idemp = e.id;

drop table if exists venta_detalle;
-- Crear la tabla VENTA DETALLE teniendo como referencia lo siguiente
create table venta_detalle(
	id int auto_increment primary key,
    idven int not null,
    idpro char(3) not null,
    cantidad int not null,
    foreign key(idven) references venta(id),
    foreign key(idpro) references producto(id)
);

-- El identificador de la Venta Detalle será autoincrementable y empezará en 100.
alter table venta_detalle auto_increment = 100;
-- Sólo se pueden vender productos que existen en la tabla producto, la cantidad mínima de venta es 1
alter table venta_detalle add constraint cantidad_valido check(cantidad >= 1);

insert into venta_detalle (idven, idpro, cantidad) values
('1', 'P02', '3'),
('1', 'P04', '2'),
('2', 'P08', '1'),
('3', 'P07', '3'),
('3', 'P01', '2'),
('3', 'P05', '5');

select v.id as 'ID. Venta', vt.id as 'ID. Venta Detalle', p.nombre as 'Producto', vt.cantidad as 'Cantidad'
from venta_detalle vt inner join venta v on vt.idven = v.id inner join producto p on vt.idpro = p.id;

-- Establecer las siguientes relaciones entre las tablas
SELECT 
  CONSTRAINT_NAME,
  `TABLE_NAME`,                            -- Foreign key table
  `COLUMN_NAME`,                           -- Foreign key column
  `REFERENCED_TABLE_NAME`,                 -- Origin key table
  `REFERENCED_COLUMN_NAME`                 -- Origin key column
FROM
  `INFORMATION_SCHEMA`.`KEY_COLUMN_USAGE`  -- Will fail if user don't have privilege
WHERE
  `TABLE_SCHEMA` = SCHEMA()                -- Detect current schema in USE 
  AND `REFERENCED_TABLE_NAME` IS NOT NULL; -- Only tables with foreign keys;

-- Agregar la fecha de nacimiento de los siguientes CLIENTES de acuerdo a lo siguiente
alter table cliente add fecnac date;
update cliente set fecnac = '1990-10-20' where id = 'C01';
update cliente set fecnac = '1992-03-12' where id = 'C05';
update cliente set fecnac = '1997-02-14' where id = 'C06';
update cliente set fecnac = '1985-07-20' where id = 'C03';
update cliente set fecnac = '1997-04-12' where id = 'C09';

select concat(upper(apellido),', ',nombre) as 'Cliente', dni as 'DNI', date_format(fecnac, '%d-%M-%Y') as 'Fec. Nacimiento'
from cliente where fecnac like '%_%';

-- Dos empleados han renunciado a la empresa, por tanto hay que eliminarlos lógicamente
update empleado set estado = 'I' where id = 'E01';
update empleado set estado = 'I' where id = 'E02';
select concat(upper(apellido),', ',nombre) as 'Empleado',
case when tipo = 'A' then 'Administrador' when tipo = 'V' then 'Vendedor' end as 'Cargo',
case when estado = 'A' then 'Activo' when estado = 'I' then 'Inactivo' end as 'Estado'
from empleado;

-- Actualizar el stock y precio de los siguientes productos de acuerdo a la imagen
update producto set stock = '80' where id = 'P01';
update producto set stock = '150' where id = 'P05';
update producto set stock = '120' where id = 'P08';
update producto set precio = '40.35' where id = 'P01';
update producto set precio = '625.35' where id = 'P05';
update producto set precio = '65.85' where id = 'P08';
select id as 'Codigo', nombre as 'Producto', stock as 'Cantidad', precio as 'Precio'
from producto where id = 'P01' or id = 'P05' or id = 'P08';

-- En la tabla EMPLEADO agregar columna y obtener el sueldo de acuerdo a las horas trabajadas y el pago por hora
select concat(upper(apellido),', ',nombre) as 'Empleado', numh as 'Hrs. Trabajadas', pagh as 'Pago x hora',
concat(numh*pagh) as 'Sueldo', case when tipo = 'A' then 'Administrador' when tipo = 'V' then 'Vendedor' end as 'Cargo'
from empleado;

-- Obtener el monto a pagar por cada producto vendido
select vt.idven as 'Venta', p.nombre as 'Producto', vt.cantidad as 'Cantidad', concat(p.precio*vt.cantidad) as 'Monto'
from venta_detalle vt inner join producto p on vt.idpro = p.id;

-- Handslabs 2
-- Poner en uso la base de datos HandsLabs y verificar que sea la base de datos activa
use HandsLabs;

-- Listar las tablas que pertenecen a la base de datos activa.
show tables;

-- Listar los clientes que no tienen fecha de nacimiento.
select concat(upper(apellido),', ',nombre) as 'Cliente', dni as 'DNI', case when fecnac is null then 'No tiene'
end as 'Fec. Nacimiento' from cliente where fecnac is null;

-- Completar las fechas de nacimiento teniendo como referencia.
update cliente set fecnac = '2005-12-25' where id = 'C08';
update cliente set fecnac = '2003-10-08' where id = 'C10';
update cliente set fecnac = '2003-01-20' where id = 'C04';
update cliente set fecnac = '1995-05-20' where id = 'C02';
update cliente set fecnac = '1975-10-30' where id = 'C07';
select concat(upper(apellido),', ',nombre) as 'Cliente', dni as 'DNI', date_format(fecnac, '%d-%M-%Y') as 'Fec. Nacimiento'
from cliente where id = 'C08' or id = 'C10' or id = 'C04' or id = 'C02' or id = 'C07';

-- Listar clientes que tienen 30 años o menos.
alter table cliente add column fecha date default current_timestamp();
select concat(upper(apellido),', ',nombre) as 'Cliente', email as 'Email', year(fecha) - year(fecnac) as 'Edad'
from cliente where year(fecha) - year(fecnac) <= 30;

-- Cuántas personas tienen edad entre 25 y 40
select count(year(fecha) - year(fecnac)) as 'Edad'
from cliente where year(fecha) - year(fecnac) < 40 and year(fecha) - year(fecnac) > 25;

-- Cantidad de empleados de tipo VENDEDOR
select count(tipo = 'V') as 'Cant. Vend.' from empleado where tipo = 'V';

-- Total de todos los sueldos de los empleados de tipo administrador
select round(sum(pagh*numh), 2) as 'T. sueldo admin.' from empleado where tipo = 'A';

-- Eliminar lógicamente al empleado Bernardo Parra Grau.
update empleado set estado = 'I' where id = 'E04';
select concat(upper(apellido),', ',nombre) as 'Empleado',
case when estado = 'A' then 'Activo' when estado = 'I' then 'Inactivo' end as 'Estado' from empleado;

-- Obtener el total de sueldos de todos los empleados vendedores que han sido eliminados lógicamente
select round(sum(pagh*numh), 2) as 'Tot. suel.' from empleado where estado = 'I' and tipo = 'V';

-- Obtener el total de sueldos de todos los empleados que son casados y están activos
select round(sum(pagh*numh), 2) as 'Tot. suel.' from empleado where civil = 'C' and estado = 'A';

-- Eliminar lógicamente a aquellos clientes cuya edad es menor e igual que 25
update cliente set estado = 'I' where id = 'C09';
update cliente set estado = 'I' where id = 'C08';
update cliente set estado = 'I' where id = 'C06';
update cliente set estado = 'I' where id = 'C04';
update cliente set estado = 'I' where id = 'C10';
select concat(upper(apellido),', ',nombre) as 'Cliente', dni as 'DNI',
concat(year(fecha)-year(fecnac)) as 'Edad', case when estado = 'A' then 'Activo' when estado = 'I' then 'Inactivo' end as 'Estado'
from cliente;

-- Listar todos los productos de todas las marcas excepto Logitech
select nombre as 'Producto', marca as 'Marca', stock as 'Stock', precio as 'Precio' from producto where marca != 'Logitech';

-- Listar productos cuyo stock es mayor e igual que 90 y el precio unitario mayor e igual que 200
select id as 'Codigo', nombre as 'Producto', stock as 'Stock', precio as 'Precio' from producto where stock >= 90 and precio >= 200;

-- Listar el detalle de venta perteneciente a la venta # 3 teniendo como referencia
alter table venta_detalle add idcli char(3) not null;
update venta_detalle set idcli = 'C03' where idven = '1';
update venta_detalle set idcli = 'C02' where idven = '2';
update venta_detalle set idcli = 'C05' where idven = '3';
update venta_detalle set idcli = 'C08' where idven = '4';
alter table venta_detalle add foreign key (idcli) references cliente(id);
select v.id as 'ID. venta', concat(upper(c.apellido),', ',c.nombre) as 'Cliente', p.nombre as 'Producto', p.precio as 'Precio',
vt.cantidad as 'Cantidad' from venta_detalle vt inner join producto p on vt.idpro = p.id inner join venta v on vt.idven = v.id
inner join cliente c on vt.idcli = c.id where v.id = 3;

-- Obtener el monto total de venta realizado por cada vendedor
alter table venta_detalle add idemp char(3) not null;
update venta_detalle set idemp = 'E02' where idven = '1';
update venta_detalle set idemp = 'E04' where idven = '2';
update venta_detalle set idemp = 'E05' where idven = '3';
update venta_detalle set idemp = 'E01' where idven = '4';
alter table venta_detalle add foreign key (idemp) references empleado(id);
select vt.idven as 'ID. venta', concat(upper(e.apellido),', ',e.nombre) as 'Empleado',
round(sum(p.precio*vt.cantidad), 2) as 'Tot. Venta' from venta_detalle vt inner join producto p on vt.idpro = p.id
inner join empleado e on vt.idemp = e.id group by vt.idemp;

-- Cancelar las ventas de código 1 y 4, es decir, eliminar lógicamente
update venta set estado = 'I' where id = 1;
update venta set estado = 'I' where id = 4;
select v.id as 'Venta', lower(e.apellido) as 'Vendedor', v.estado as 'Estado' from venta v
inner join empleado e on v.idemp = e.id;

-- Obtener el total de ventas activas e inactivas
select case when v.estado = 'A' then 'Activo' when v.estado = 'I' then 'Inactivo' end as 'Estado', 
round(sum(p.precio*vt.cantidad), 2) as 'Tot. venta' from venta_detalle vt 
inner join venta v on vt.idven = v.id inner join producto p on vt.idpro = p.id group by v.estado;

-- Obtener el listado de clientes que no han participado en ventas realizadas
select c.id as  'Codigo', upper(c.apellido) as 'Apellido', c.dni as 'DNI', c.email as 'Email'
from cliente c where not exists (select*from venta v where c.id = v.idcli);

-- Listar los productos que no han sido incluidos en ninguna venta
select p.id as 'Codigo', p.nombre as 'Producto', p.precio as 'Precio', p.stock as 'Stock'
from producto p where not exists (select * from venta_detalle vt where p.id = vt.idpro);




