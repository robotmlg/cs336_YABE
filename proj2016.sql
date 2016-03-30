drop table users;
create table users(
	username varchar(16) primary key,
	password_hash binary(32) not null, 
	password_salt varchar(8) not null,
	age integer not null,
	name varchar(32) not null,
	address varchar(64) not null
);

drop table messages;
create table messages(
	message_id integer primary key,
	to_user varchar(16) references users,
	from_user varchar(16) references users,
	body text, 
	subject varchar(64)
);

drop table cust_reps;
create table cust_reps(
	username varchar(16) references users
);

drop table admins;
create table admins(
	username varchar(16) references users
);

drop table product;
create table product(
	productID integer primary key,
	brand varchar(24)
);

drop table auction;
create table auction(
	auctionID integer primary key,
  start_date date not null,
  end_date date not null,
  reserve_price decimal(10,2),
  start_price decimal(10,2) not null,
  quantity integer not null,
  item_condition varchar(16) not null,
  productID integer references product
);

drop table participatesIn;
create table participatesIn(
	username varchar(16) references users,
	auctionID integer references auction,
	primary key (username, auctionID)
);

drop table bid;
create table bid(
	bidID integer primary key,
	amount decimal(10,2) not null,
	time timestamp not null,
	username varchar(16) references users,
	auctionID integer references auction
);

drop table storage;
create table storage(
	productID integer references product,
	brand varchar(24) references product,
	primary key (productID)
);

drop table psu;
create table psu(
	productID integer references product,
	brand varchar(24) references product,
	primary key (productID)
);

drop table motherboard;
create table motherboard(
	productID integer references product,
	brand varchar(24) references product,
	primary key (productID)
);

drop table cpu;
create table cpu(
	productID integer references product,
	brand varchar(24) references product,
	primary key (productID)
);

drop table ram;
create table ram(
	productID integer references product,
	brand varchar(24) references product,
	primary key (productID)
);

drop table fan;
create table fan(
	productID integer references product,
	brand varchar(24) references product,
	primary key (productID)
);

drop table gpu;
create table gpu(
	productID integer references product,
	brand varchar(24) references product,
	primary key (productID)
);

drop table case_hw;
create table case_hw(
	productID integer references product,
	brand varchar(24) references product,
	primary key (productID)
);

drop table other;
create table other(
	productID integer references product,
	brand varchar(24) references product,
	primary key (productID)
);




