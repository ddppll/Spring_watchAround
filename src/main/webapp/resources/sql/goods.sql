create table goods(
	email varchar(50) not null,
	productIdx int not null, 
	foreign key(productIdx)
	references product(idx) on update cascade
	);

show tables;

desc product;