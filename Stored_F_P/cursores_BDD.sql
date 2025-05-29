#9)
delimiter //
	create procedure getCiudadesOffices (out listadooficinas varchar(4000))
	begin
		declare hayFilas boolean default 1;
		declare ciudadObtenida varchar(45) default "";
		declare ciudadesCursor cursor for select city from offices;
		declare continue handler for not found set hayFilas = 0;
		set listadooficinas= "";
		open ciudadesCursor;
			officesLoop:loop
				fetch ciudadesCursor into ciudadObtenida;
				if hayFilas = 0 then
					leave officesLoop;
				end if;
				set listadooficinas = concat(ciudadObtenida, ", ", listadooficinas);
			end loop officesLoop;
		close ciudadesCursor;
	end//
delimiter ;
call getCiudadesOffices(@lista);
select @lista;
drop procedure getCiudadesOffices;

#10)

CREATE TABLE CancelledOrders (
  orderNumber int,
  orderDate date NOT NULL,
  shippedDate date DEFAULT NULL,
  customerNumber int NOT NULL,
  PRIMARY KEY (orderNumber),
  FOREIGN KEY (customerNumber) REFERENCES customers (customerNumber)
);

delimiter //
	create procedure insertCancelledOrders (out cantidad int)
	begin
		declare hayFilas boolean default 1;
		declare orderN int;
		declare orderD date;
		declare enviado date;
		declare clienteN int;
		declare ordenesCanceladas cursor for select orderNumber , orderDate , shippedDate , 
			customerNumber from orders where status = "Cancelled" ;
		declare continue handler for not found set hayFilas = 0;
		select count(orderNumber) into cantidad from orders where status = "Cancelled" ;
		open ordenesCanceladas;
			orderLoop:loop
				fetch ordenesCanceladas into orderN, orderD, enviado, clienteN;
				if hayFilas = 0 then
					leave orderLoop;
				end if;
				insert into CancelledOrders values( orderN , orderD , enviado , clienteN);
			end loop orderLoop ;
		close ordenesCanceladas;
	end//
delimiter ;
call insertCancelledOrders(@canti);
select @canti; 


#11)
delimiter //
	create procedure altercommentorder(in p_customernumber int)
	begin
		declare done int default 1;
		declare v_ordernumber int;
		declare v_total decimal(10,2);
		declare cur_ordenes cursor for select ordernumber from orders
			where customernumber = p_customernumber;
		declare continue handler for not found set done = 0;
		open cur_ordenes;
			bucle: loop
				fetch cur_ordenes into v_ordernumber;
				if done then
					leave bucle;
				end if;
				if exists (select 1 from orders where ordernumber = v_ordernumber 
							and (comments is null or trim(comments) = '')) then
					select sum(quantityordered * priceeach) into v_total from orderdetails
						where ordernumber = v_ordernumber;
					update orders set comments = concat('el total de la orden es ', format(v_total, 2))
						where ordernumber = v_ordernumber;
				end if;
			end loop;
		close cur_ordenes;
	end//
delimiter ;
call altercommentorder(103);

#12)
delimiter //
	create procedure sp_telefonos_clientes_cancelaron( out telefonos_cancelados text)
	begin
		declare done int default 1;
		declare v_telefono varchar(50);
		declare telefonos_temp text default '';
		declare cur cursor for select phone from customers where exists (select 1 from orders
			where customernumber = customernumber and status = 'cancelled')
			and not exists (select 1 from orders where customernumber = customernumber 
			and status != 'cancelled');
		declare continue handler for not found set done = 0;
		open cur;
			bucle: loop
				fetch cur into v_telefono;
				if done then
					leave bucle;
				end if;
				if telefonos_temp = '' then
					set telefonos_temp = v_telefono;
				else
					set telefonos_temp = concat(telefonos_temp, ', ', v_telefono);
				end if;
			end loop;
		close cur;
		set telefonos_cancelados = telefonos_temp;
	end//
delimiter ;
call sp_telefonos_clientes_cancelaron(@telefonos);
select @telefonos;

#13)
alter table employees add column comision decimal(10,2) default 0.00;

delimiter //
	create procedure actualizarcomision()
	begin
		declare hay_filas int default 1;
		declare v_employee int;
		declare v_total decimal(10,2);
		declare v_comision decimal(10,2);
		declare cursorr cursor for select employeenumber from employees;
		declare continue handler for not found set hay_filas = 0;
		open cursorr;
			buclee: loop
				fetch cursorr into v_employee;
				if hay_filas = 0 then
					leave buclee;
				end if;
				select sum(quantityordered * priceeach) into v_total from customers
					join orders on customernumber = customernumber
					join orderdetails on ordernumber = ordernumber
					where salesrepemployeenumber = v_employee;
				if v_total is null then
					set v_total = 0.00;
				end if;
				if v_total > 100000 then
					set v_comision = v_total * 0.05;
				else if v_total >= 50000 then
					set v_comision = v_total * 0.03;
				else
					set v_comision = 0.00;
				end if;
                end if;
				update employees set comision = v_comision where employeenumber = v_employee;
			end loop;
		close cursorr;
	end//
delimiter ;
call actualizarcomision();

#14)
delimiter //
	create procedure asignarempleados()
	begin
		declare hay_filas int default 1;
		declare v_customer int;
		declare v_empleado int;
		declare empleadoscursor cursor for select customernumber from customers 
			where salesrepemployeenumber is null;
		declare continue handler for not found set hay_filas = 0;
		open empleadoscursor;
			bucle: loop
				fetch empleadoscursor into v_customer;
				if done then
					leave read_loop;
				end if;
				select employeenumber into v_empleado from employees 
						left join ( select salesrepemployeenumber, count(*) as total from customers 
						where salesrepemployeenumber is not null group by salesrepemployeenumber)
						on employeenumber = salesrepemployeenumber order by ifnull(total, 0) asc limit 1;
				update customers set salesrepemployeenumber = v_empleado where customernumber = v_customer;
			end loop;
		close empleadoscursor;
	end//
delimiter ;
call asignarempleados();

#stock))

#1))
delimiter //
	create procedure ingresoSemanal()
	begin 
		declare hayfilas boolean default 1;
		declare codP int;
		declare cant int;
		declare ingresoCursor cursor for select codProducto,cantidad from ingresostock 
			join ingresostock_producto on idIngreso = IngresoStock_idIngreso  
			join producto on ingresostock_producto.Producto_codProducto = codProducto 
			where week(fecha) = week(current_date()); 
		declare continue handler for not found set hayFilas = 0;
		open ingresoCursor;
			bucle: loop
				fetch ingresoCursor into codP, cant;
				if hayfilas= 0 then
					leave bucle; 
				end if;	
				update producto set stock = stock + cant where codProducto = codP;
			end loop;
		close ingresoCursor;
	end //
delimiter ;   
call ingresoSemanal();

#2) 
delimiter //
	create procedure menosPrecio()
	begin
		declare hayfilas boolean default 1; 
		declare cant int;
		declare prodCod int;
		declare reductorCursor cursor for select sum(cantidad) , producto.codProducto
			from producto 
			join pedido_producto on producto.codProducto= Pedido_producto.codProducto 
			join pedido on pedido_producto.Pedido_idPedido = pedido.idPedido
			where week(fecha) = week(current_date())
			group by producto.codProducto
			having sum(cantidad) < 100; 
		declare continue handler for not found set hayfilas= 0;
		open reductorCursor;
			bucle : loop
				fetch reductorCursor into cant, prodCod;
				if hayfilas = 0 then
					leave bucle;
				end if; 
				update producto set precio = precio - precio * 10 / 100 where codProducto = prodcod;
			end loop;
		close reductorCursor;
	end //
delimiter ; 
call menosPrecio();

#3)

delimiter //
	create procedure mayorPrecio()
	begin
		declare hayfilas boolean default 1; 
		declare prod_proveCod int;
		declare aumentadorCursor cursor for select Producto_codProducto
			from Proveedor_idProveedor 
			join producto on Producto_codProducto= codProducto;
		declare continue handler for not found set hayfilas= 0;
		open aumentadorCursor;
			bucle : loop
				fetch aumentadorCursor into prod_proveCod ;
				if hayfilas = 0 then
					leave bucle;
				end if; 
				update producto set precio = precio + precio * 0.10
					where codProducto = prodcod;
			end loop;    
		close aumentadorCursor;
	end //
delimiter ; 
call mayorPrecio();

#4))

delimiter //
	create procedure actualizar_nivel_proveedores()
	begin
		declare hayfilas boolean default 1; 
		declare v_proveedor_id int;
		declare v_cantidad_ingresos int;
		declare v_nivel varchar(10);
		declare fecha_limite date;
		declare cur_proveedores cursor for select idProveedor from proveedor;
		declare continue handler for not found set hayfilas= 0;
		set fecha_limite = date_sub(curdate(), interval 2 month);
		open cur_proveedores;
			bucle: loop
				fetch cur_proveedores into v_proveedor_id;
				if done then
					leave bucle;
				end if;
				select count(*) into v_cantidad_ingresos from ingresostock 
					where idProveedor = v_proveedor_id and fecha >= fecha_limite;
				if v_cantidad_ingresos <= 50 then
					set v_nivel = 'bronce';
				elseif v_cantidad_ingresos <= 100 then
					set v_nivel = 'plata';
				else
					set v_nivel = 'oro';
				end if;
				update proveedores set nivel = v_nivel where idProveedor = v_proveedor_id;
			end loop;
		close cur_proveedores;
	end//
delimiter ;
call actualizar_nivel_proveedores();

#5))

delimiter //
	create procedure actualizar_precio_unitario()
	begin
		declare hayfilas boolean default 1; 
		declare v_pedido_id int;
		declare v_producto_id int;
		declare v_precio_actual decimal(10,2);
		declare cur_detalles cursor for select Pedido_idPedido, Producto_codProducto
			from pedido_producto join pedido on Pedido_idPedido = idPedido join estado 
			on Estado_idEstado = idEstado where nombre = 'pendiente';
		declare continue handler for not found set hayfilas= 0;
		open cur_detalles;
			bucle: loop
				fetch cur_detalles into v_pedido_id, v_producto_id;
				if hayfilas then
					leave bucle;
				end if;
				select precio into v_precio_actual from productos 
					where codProducto = v_producto_id;
				update pedido_producto set precio = v_precio_actual 
					where idPedido = v_pedido_id and codProducto = v_producto_id; 
			end loop;
		close cur_detalles;
	end//
delimiter ;
