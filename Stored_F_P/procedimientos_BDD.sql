#1)))
delimiter //
	create procedure listarProd(out cantidad int)  
	begin
		declare average int default 0;
		select avg(buyPrice) into average from products;
		select * from products where buyPrice> average;
		select count(*) into cantidad from products where buyPrice > average ;
	end //
delimiter ;
call listarProd(@canti);
select @canti;

#2)))
delimiter //
	create procedure ordenarnum(out cantidad int, in num int)  
	begin
		select count(orderNumber) into cantidad from orderdetails where orderNumber= num ;
		delete from orderdetails where orderNumber= num; 
		delete from orders where orderNumber= num;
	end //
delimiter ;
call ordenarnum (@canti, 10100);
select @canti;

#3)))
delimiter //
	create procedure borrar_linea_producto(product_line varchar(50))
	begin
		declare cantidad int;
		declare mensaje varchar(255);
		select count(*) into cantidad from products where productline = product_line;
		if cantidad > 0 then
			set mensaje = 'la línea de productos no pudo borrarse porque contiene productos asociados.';
		else
			delete from productlines where productline = product_line;
			set mensaje = 'la línea de productos fue borrada';
		end if;
		select mensaje as resultado;
	end//
delimiter ;

#4)))
delimiter //
	create procedure PorEstados(out cantidad int, out cantidad2 int)  
	begin
		select count(orderNumber) into cantidad from orders where status= 'Shipped';
		select count(orderNumber) into cantidad2 from orders where status= 'In process';
	end //
delimiter ;
call PorEstados (@canti, @canti2);
select @canti;
select @canti2;

#5)))
delimiter //
create procedure empleados_con_subordinados()
begin
    select 
        employeeNumber, concat(firstName, ' ', lastName) as nombre_empleado, count(employeeNumber) 
        as cantidad_subordinados from employees e
    join employees on reportsTo = employeeNumber
    group by employeeNumber, firstName, lastName;
end//
delimiter ;
call empleados_con_subordinados;

#6)))
delimiter //
	create procedure ListaOrdenesConTotal(out precio int)  
	begin
		select orders.orderNumber, sum(quantityOrdered * priceEach ) AS totalPedido from orderdetails 
		join orders on orderdetails.orderNumber = orders.orderNumber group by orders.orderNumber 
		order by orders,orderNumber ;
	end //
delimiter ;
call ListaOrdenesConTotal (@precio);
select @precio;
drop procedure ListaOrdenesConTotal;

#7)))
delimiter //
	create procedure ordenes_por_cliente()
	begin
		select customernumber, customername, ordernumber, sum(od.quantityordered * od.priceeach) 
			as total_orden from customers join orders on customers.customernumber = orders.customernumber
			join orderdetails on orders.ordernumber = orderdetails.ordernumber
		group by customernumber, customername, ordernumber
		order by customernumber, ordernumber;
	end//
delimiter ;
call ordenes_por_cliente ();

#8)))
delimiter //
	create procedure actualizar_comentario_orden( in p_ordernumber int, in p_comentario text)
	begin
		declare filas_afectadas int;
		update orders set comments = p_comentario where ordernumber = p_ordernumber;
		set filas_afectadas = row_count();
		if filas_afectadas > 0 then
			select 1 as resultado;
		else
			select 0 as resultado;
		end if;
	end//
delimiter ;
call actualizar_comentario_orden(10100, 'entregado antes de lo esperado');

