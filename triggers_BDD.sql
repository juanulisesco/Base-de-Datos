#1))
create table customers_audit(
	IdAuditc int auto_increment not null primary key,
    Operacion char(6),
    Usuario varchar(45),
	Last_date_modified date,
	customerNumber int,
    customerName varchar(45),
    contactLastName varchar (45)
);

#a)
delimiter //
	create trigger a_customers_i after insert on customers for each row
	begin
		insert into customers_auditc values(null, 'Insert', current_user() ,
			current_date(), new.customerNumber, new.customerName, new.contactLastName);
	end//
delimiter ;

#b)
delimiter //
	create trigger b_customers_u before update on customers for each row
	begin
		insert into customers_auditc values(IdAudit, 'Update', current_user(), current_date(),
			old.customerNumber, old.customerName, old.contactLastName);
	end//
delimiter ;	

#c)
delimiter //
	create trigger b_customers_d before delete on customers for each row
	begin
		insert into customers_auditc values(IdAudit, 'Deleted', current_user(), current_date(),
			old.customerNumber, old.customerName, old.contactLastName);
	end//
delimiter ;	

#2))
create table employees_audit(
	idAuditoriaE int auto_increment not null primary key,
    employeesNUM int,
    apellido varchar(45),
    nombre varchar(45),
	operacion char(6),
    usuario varchar(45),
    ultima_fechaMOD DATE
);

#a)
delimiter //
	create trigger a_employees_i after insert on employees for each row
	begin
		insert into employees_audit values(null, new.employeesNUM , new.apellido , new.nombre,
        'Insert', current_user() , current_date());
	end//
delimiter ;

#b)
delimiter //
	create trigger b_employees_u before update on employees for each row
	begin
		insert into employees_audit values(idAuditoriaE, old.employeesNUM , old.apellido ,
			old.nombre ,'Update', current_user() , current_date());
	end//
delimiter ;	

#c)
delimiter //
	create trigger b_employees_d before delete on employees for each row
	begin
		insert into employees_audit values(idAuditoriaE, old.employeesNUM , old.apellido , old.nombre ,
        'Delete', current_user() , current_date());
	end//
delimiter ;	

#3))

create table products_audit(
    idAuditoriap int auto_increment not null primary key,
    operacion char(6),
    usuario varchar(45),
    ultima_fechaMOD DATE,
    productCode int,
    productName varchar(45),
    productLine varchar(45)
	
);

#)
delimiter //
	create trigger BPD before delete on products for each row
	begin
		if exists(select orderDate from orders 
			join orderdetails on orders.orderNumber= orderdetails.orderNumber 
			where orderDate> '2025-02-24' and orderdetails.productCode= old.productCode) then 
			signal sqlstate "45000" set message_text= "Error, tiene ordenes asociadas";
		end if;
	end//
delimiter ;	
delete from products where productCode="S18_2325";
drop trigger BPD;

#stock/

#1)
delimiter //
	create trigger a_pedido_producto_u after update on pedido_producto for each row
	begin
		update ingresostock_producto set cantidad = cantidad - new.cantidad 
			where Producto_codProducto = new.Producto_codProducto;
	end//
delimiter ;	

#2)
delimiter // 
	create trigger b_ingreso_stock_d before delete on ingresostock for each row
    begin
		delete from ingresostock_producto
			where ingresostock_producto.IngresoStock_idIngreso= ingresostock.idIngreso;
	end//
delimiter ;

#3)
delimiter //
	create trigger a_clientes_categoria_u after insert on pedido for each row
    begin
		declare total int default 0;
        declare categoria varchar(10);
        select sum( cantidad * precioUnitario) into total from pedido_producto join pedido on
			pedido_producto.Pedido_idPedido = pedido.idPedido join cliente on 
            Cliente_codCliente = codCliente where old.idPedido = pedido.idPedido;
		select nombre into catergoria from categoria;
		if total < 50000 
			then set categoria="bronce";
		else if total between 50000 and 100000 
			then set categoria="plata";
		else 
			set categoria="oro";
		end if;
        end if;
    end//
delimiter ;

#4)
delimiter //
	create trigger a_ingresostock_producto_i after insert on ingresostock_producto for each row
    begin
		update producto set producto.stock = old.cantidad
			where old.Producto_codProducto = producto.codProducto;
	end//
delimiter ;