select nombre from proveedor where ciudad = "La Plata" ;
delete from articulo where codigo not in (select articulo_codigo from compuesto_por where material_codigo = null);
select codigo, descripcion from articulo join compuesto_por on codigo=articulo_codigo 
join material on material_codigo=codigo 
join provisto_por on material_codigo=proveedor_codigo
join proveedor on proveedor_codigo=codigo where nombre = "Lopez";