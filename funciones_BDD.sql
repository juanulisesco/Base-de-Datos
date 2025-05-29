#//////classicmodels

#1)
delimiter //
	create function CuentaOrde(estado text, fechaI date, fechaF date ) returns int deterministic 
	begin
		declare cantidad int default 0;
		select count(orderNumber) into cantidad from orders where status = estado and orderDate< fechaF 
			and orderDate> fechaI ;
		return cantidad;
	end//
delimiter ;
select CuentaOrde("Cancelled", "2025-03-10", current_date());

#2)
delimiter //
	create function CuentaOrdeEntre(fecha1 date, fecha2 date) returns int deterministic 
	begin
		declare cantidad int default 0;
		select count(orderNumber) into cantidad from orders where shippedDate 
			between fecha1 and fecha2;
		return cantidad;
	end//
delimiter ;
select CuentaOrdeEntre("2000-03-12", "2200-03-12");

#3)
delimiter //
	create function CiudaadEmples(Numero int) returns text deterministic
	begin
		declare ciudadpai text;
		select city into ciudadpai from offices 
			join employees on employees.officeCode = offices.officeCode where employees.employeeNumber 
            in (select employeeNumber from employees join customers 
            on employees.employeeNumber = customers.salesRepEmployeeNumber 
			where customerNumber= numero);
		return ciudadpai;
	end//
delimiter ;
select CiudaadEmples(103); 

#4)
delimiter //
	create function LineaProd(Linea text) returns int deterministic
	begin
		declare cantidad int;
		select count(produtCode) into cantidad from products 
			where products.productLine = linea;
		return cantidad;
	end//
delimiter ;
select LineaProd('Classic Cars'); 

#5)
delimiter //
	create function Codgo(Cod int) returns int deterministic
	begin
		declare cantidad int;
		select count(customerNumber) into Cod from customers 
			join employees on employees.employeeNumber = customers.salesRepEmployeeNumber 
			join offices on employees.officeCode = offices.officeCode 
			where offices.officeCode = Cod;
		return cantidad;
	end//
delimiter ;
select Codgo(1); 

#6)
delimiter //
	create function ordenadores(Cod int) returns int deterministic
	begin
		declare cantidad int;
		select count(orderNumber) into Cantidad from orders 
			join customers on orders.customerNumber = customers.customerNumber
			join employees on employees.employeeNumber = customers.salesRepEmployeeNumber 
			join offices on employees.officeCode = offices.officeCode
			where offices.officeCode = Cod;
		return cantidad;
	end//
delimiter ;
select ordenadores(10100); 

#7)
delimiter //
	create function nroOrdenyProd( nroOrden int, nroProd varchar(45)) returns int deterministic
	begin
		declare beneficio int;
		select (priceEach-buyPrice) into beneficio from orders 
			join orderdetails on orders.orderNumber= orderdetails.orderNumber 
			join products on orderdetails.productCode = products.productCode ;
		return beneficio;
		end//
delimiter ;
select nroOrdenyProd(10100,"S10_1678"); 

#8)
delimiter //
	create function OrdNume (ordern int) returns varchar (45) deterministic 
	begin 
		declare estado varchar(45);
		select status into estado from orders where orderNumber = OrdNume;
		if orders.status = cancelado then set var -1;
		else set var 0;
		end if;
		return var; 
end//
delimiter ;
select OrdNume(10100);

#9)
delimiter //
	create function nroOrdenyProd(NumClie int ) returns date deterministic
	begin
		declare fechamin date;
		select min(orderDate) into fechamin from orders join customers 
        on customers.customerNumber= orders.customersNumber where customerNumber= NumClie;
		return fechamin;
	end//
delimiter ;
select nroOrdenyProd(103); 

#10)
delimiter //
	create function porcentaje_ventas_bajo(product_code varchar(15)) returns decimal (5,2) deterministic
		begin
			declare total_ventas int;
			declare ventas_bajo_msrp int;
			declare porcentaje decimal(5,2);
			declare msrp decimal(10,2);
			select msrp into msrp from products where productcode = product_code;
			if msrp is null then
				return null;
			end if;
			select count(*) into total_ventas from orderdetails where productcode = product_code;
			if total_ventas = 0 then
				return null;
			end if;
			select count(*) into ventas_bajo_msrp from orderdetails where productcode = product_code 
				and priceeach < msrp;
			set porcentaje = (ventas_bajo_msrp / total_ventas) * 100;
			return porcentaje;
	end//
delimiter ;
select fn_porcentaje_ventas_bajo_msrp('s18_1749') as porcentaje_bajo_msrp;

#11)
delimiter //
	create function nroOrdenyProd(CodProd int) returns date deterministic
	begin
		declare UlTFec date;
		select max(orderDate) into UltFec from orders
			join orderdetails on ordendetails.orderNumber= orders.orderNumber 
			join products on products.productCode= ordendetails.productCode 
            where products.productCode= CodProd;
		return UltFec;
	end//
delimiter ;
select nroOrdenyProd(); 

#12)
delimiter //
	create function fn_mayor_precio_producto_en_rango (desde date, hasta date, product_code varchar(15))
		returns decimal(10,2) deterministic
	begin
		declare mayor_precio decimal(10,2);
		select max(od.priceeach) into mayor_precio from orderdetails join orders 
			on ordernumber = ordernumber
			where productcode = product_code and orderdate between desde and hasta;
		if mayor_precio is null then
			return 0;
		end if;
		return mayor_precio;
	end//
delimiter ;
select fn_mayor_precio_producto_en_rango('2003-01-01', '2004-12-31', 's18_1749') as mayor_precio;


#13)
delimiter //
	create function nroOrdenyProd(NumEmpl int) returns int deterministic
	begin
		declare CantidadCl int;
		select count(customerNumber) into CantidadCl from customers 
			where salesRepEmployeeNumber = NumEmpl;
		return CantidadCl;
	end//
delimiter ;
select nroOrdenyProd(1002); 

#14)
delimiter //
	create function nroOrdenyProd(NumEmpl int) returns text deterministic
	begin
		declare Apellido varchar(45);
		select lastName into Apellido from employees where employeeNumber = NumEmpl;
		return fechamin;
	end//
delimiter ;
select nroOrdenyProd(1002); 

#////

#1))
delimiter //
	create function optenerNivel(nempleado int) returns text deterministic 
	begin
		declare nivel text default "nivel 1";
		declare cantidad int;
			select count(*) into cantidad from employees where reportsTo = nempleado;
			if cantidad > 10 and cantidad < 20 then 
				set nivel = "nivel 2";
			else if cantidad > 20 then 
				set nivel = "nivel 3";
			end if; 
			end if;
		return nivel;
	end//
delimiter ;
select optenerNivel(1002);

#2))
delimiter //
	create function Rsat(fecha1 date, fecha2 date) returns int deterministic 
	begin
		declare cantidad int default 0;
		set cantidad= fecha2- fecha1;
		return cantidad;
	end//
delimiter ;
select Rsat('2003-01-06', '2003-01-10');

#3))
delimiter //
	create function mEstado(fecha1 date, fecha2 date) returns int deterministic 
	begin
		declare cantidad int default 0;
		select count(*) into cantidad from orders where Rsat (fecha1, fecha2)>10 ;
		update orders set status = "cancelado" where Rsat(fecha1,fecha2)>10;
		return cantidad; 
	end;
delimiter ;
select mEstado('2003-01-06', '2003-01-10');
drop function borrarProv; 

#4))
delimiter //
	create function borrarProv(papota int, papota2 varchar(45)) returns int deterministic 
	begin
		declare cantidad int default 0;
		select quantityOrdered into cantidad from orderdetails where papota= orderNumber 
			and  productCode= papota2;
		delete from orderdetails where papota= orderNumber and  productCode= papota2;
		return cantidad;
	end//
delimiter ;
select borrarProv(10100, 'S10_1678');

#5))
delimiter //
	create function Papugome(producto varchar(45)) returns varchar(45) deterministic 
	begin
		declare devolver varchar(45);
		declare cantidad int default 0;
		select quantityinStock into cantidad from products where productCode= producto;
		if cantidad>= 5000 then set devolver= 'Sobrestock';
		else if cantidad<= 1000 then set devolver= 'Bajo Stock';
		else set devolver= 'Stock Adecuado';
		end if;
		end if;
		return devolver;
	end //
delimiter ;
select Papugome('S10_1678');

#6))
delimiter //
	create function fn_top3_productos_mas_vendidos(anio int) returns varchar(255) deterministic
	begin
		declare resultado varchar(255);
		select group_concat(productname order by total_cantidad desc separator ', ') into resultado
			from (
				select productcode, sum(quantityordered) as total_cantidad
				from orderdetails join orders on orderdetails.ordernumber = orders.ordernumber
				where year(orderdate) = anio group by oproductcode order by total_cantidad desc limit 3
			)as top3 join products on productcode = productcode;
		return ifnull(resultado, '');
	end//
delimiter ;
select fn_top3_productos_mas_vendidos(2004) as top3;

#//////stock

#tema 1:
#punto 1) 

delimiter //
create function ClienteFrecuente (codCliente int) returns varchar (45) deterministic 
begin
declare frecuente varchar(45);
declare cantTotal int default 0;
declare cantCliente int default 0;
select count(idPedido) into cantTotal from pedido where timestampdiff(month, fecha, current_date()) < 6 ;
select count(Cliente_codCliente) into cantCliente from pedido where codCliente = Cliente_codCliente 
and timestampdiff(month, fecha, current_date()) < 6 ;
if cantCliente / cantTotal >= 0.05 then set frecuente= "Es frecuente";
else set frecuente = "No es frecuente";
end if;
return frecuente;
end //
delimiter ;
select ClienteFrecuente ('1');

#punto 4)
drop function Estados;
delimiter //
create function Estados (codCliente int) returns int deterministic 
begin
declare cantTotale int default 0;
select count(idPedido) into cantTotale from pedido 
join estado on Estado_idEstado= idEstado where nombre= "No pagado" and codCliente= Cliente_codCliente;  
return cantTotale;
end //
delimiter ;
select Estados ('1');

#tema 2:
#punto 1)
delimiter //
create function pepe (codProv int) returns int deterministic 
begin
declare cantTotale int default 0;
declare cantTotales int default 0;
declare prove varchar(45);
declare canta varchar(45);
select count(idIngreso) into cantToales;
select count(idPoveedor) into prove from proveedor where idProveedor= codProv;  
return cantTotale;
end //
delimiter ;
select pepe ('1');

#punto 2)

delimiter //
create function promProve ( codeprod int) returns int deterministic 
begin
declare promedio int default 0;
select avg (precio) into promedio from producto where codeprod = codProducto ;  
return promedio;
end //
delimiter ;
select promProve(1);

#tema 3:
#punto 1)
delimiter //
create function cantidades ( codeprod int) returns int deterministic 
begin
declare cantidad int default 0;
select sum(cantEntradas) into cantidad from compra where funcion_idFuncion = codeprod;  
return promedio;
end //
delimiter ;
select promProve(1);

#punto 2)
delimiter //
create function calcula ( codClie int) returns int deterministic 
begin
declare cantidad int;
select sum(cantEntradas) into cantidad from compra where funcion_idFuncion = codClientes;  
return cantidad;
end //
delimiter ;
delete from cliente where cantidades(codCliente)<=0;
