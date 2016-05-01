drop table users;
create table users(
	username varchar(16) primary key,
	password_hash char(60) binary not null, 
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
	subject varchar(64),
	send_time timestamp
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
	brand varchar(24),
	model varchar(24),
	extraInfo Text
);

drop table auction;
create table auction(
	auctionID integer primary key,
	start_date datetime not null,
	end_date datetime not null,
	reserve_price decimal(10,2),
	start_price decimal(10,2) not null,
	quantity integer not null,
	item_condition varchar(16) not null,
	maxBid decimal(10,2) not null,
	numBids integer not null,
	productID integer references product,
	username varchar(16) references users,
	sponsored boolean
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
	max_amount decimal(10,2),
	time timestamp not null,
	username varchar(16) references users,
	auctionID integer references auction
);

drop table storage;
create table storage(
	productID integer references product,
	capacityInGB decimal(9,3) not null,
	storageType varchar(3) not null,
	primary key (productID)
);

drop table psu;
create table psu(
	productID integer references product,
	power integer not null,
	modular boolean not null,
	primary key (productID)
);

drop table motherboard;
create table motherboard(
	productID integer references product,
	pcieSlots integer not null,
	memorySlots integer not null,
	maxRAM integer not null,
	socketType varchar(16) not null,
	chipset varchar(16) not null,
	onBoardSound boolean not null,
	onBoardVideo boolean not null,
	primary key (productID)
);

drop table cpu;
create table cpu(
	productID integer references product,
	cores integer not null,
	clockSpeed decimal(4,2) not null,
	socketType varchar(16) not null,
	primary key (productID)
);

drop table ram;
create table ram(
	productID integer references product,
	capacity integer not null,
	memoryType varchar(4) not null,
	clockSpeed integer not null,
	primary key (productID)
);

drop table fan;
create table fan(
	productID integer references product,
	dimensions varchar(15) not null,
	flowrate integer not null,
	maxRPM integer not null,
	primary key (productID)
);

drop table gpu;
create table gpu(
	productID integer references product,
	coreClockSpeed decimal(4,2) not null,
	numCores integer not null,
	memoryCapacity integer not null,
	memoryClockSpeed integer not null,
	memoryType varchar(4) not null,
	numHDMI integer not null,
	numDVI integer not null,
	numDP integer not null,
	powerRequirement integer not null,
	primary key (productID)
);

drop table case_hw;
create table case_hw(
	productID integer references product,
	dimensions varchar(15) not null,
	numCaseFans integer not null,
	isLITT boolean not null,
	primary key (productID)
);

drop table other;
create table other(
	productID integer references product,
	primary key (productID)
);

drop table item_types;
create table item_types(
	table_name varchar(12) primary key,
	nice_name varchar(16)
);
insert into item_types (table_name,nice_name) VALUES ("case_hw","Cases");
insert into item_types (table_name,nice_name) VALUES ("cpu","CPUs");
insert into item_types (table_name,nice_name) VALUES ("fan","Fans");
insert into item_types (table_name,nice_name) VALUES ("gpu","Video Cards");
insert into item_types (table_name,nice_name) VALUES ("motherboard","Motherboards");
insert into item_types (table_name,nice_name) VALUES ("other","Other");
insert into item_types (table_name,nice_name) VALUES ("psu","Power Supplies");
insert into item_types (table_name,nice_name) VALUES ("ram","Memory");
insert into item_types (table_name,nice_name) VALUES ("storage","Storage");

delimiter $$
create trigger autobid
after insert on bid
for each row
begin
SET @curr_high = (SELECT MAX(amount) FROM bid WHERE auctionID=new.auctionID);
SET @curr_ID   = (SELECT bidID FROM bid WHERE amount=@curr_high AND 
    auctionID=new.auctionID);
SET @curr_user = (SELECT username FROM bid WHERE bidID=@curr_ID);
SET @curr_max  = (SELECT max_amount FROM bid WHERE bidID=@curr_ID);
if new.amount+1 < @curr_max
then
    SET @new_ID = (SELECT MAX(bidID) FROM bid) + 1;
    INSERT INTO bid (bidID, amount, max_amount, time, username, auctionID)
        VALUES (@new_ID, new.amount+1, @curr_max, NOW(), @curr_user, new.auctionID);
end if;
end$$
delimiter ;

