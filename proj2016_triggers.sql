
delimiter $$

drop trigger if exists bid_check$$
create trigger bid_check
before insert on bid
for each row
begin
SET @curr_high = (SELECT MAX(amount) FROM bid WHERE auctionID=new.auctionID);
if new.amount <= @curr_high
then 
SET new.amount = null; -- set amount to null so that insert will get rejected
else 
-- bid is good, message old high bidder
SET @max_msgID = (SELECT MAX(message_id) FROM messages);
if COALESCE(@max_msgID, '') = ''
then SET @max_msgID = 0;
end if;
SET @curr_ID   = (SELECT bidID FROM bid WHERE amount=@curr_high AND 
    auctionID=new.auctionID);
SET @curr_user = (SELECT username FROM bid WHERE bidID=@curr_ID);
INSERT INTO messages (message_id, to_user, from_user, send_time, subject, body) VALUES
(@max_msgID + 1, @curr_user, "YABE", NOW(), "You've been outbid!",
CONCAT("You've been outbid on auction ",new.auctionID," by ",new.username,"!"));
end if;
end$$

drop trigger if exists max_bid_update$$
create trigger max_bid_update
after insert on bid
for each row
begin
UPDATE auction SET maxBid=new.amount WHERE auctionID=new.auctionID;
end$$


drop procedure if exists end_auction$$
create procedure end_auction()
begin
SET @curr_time = NOW();
SELECT COUNT(*) FROM auction WHERE TIMESTAMPDIFF(SECOND,@curr_time,end_date)<0 
    AND completed!=true INTO @n;
SET @i=1;
WHILE @i <= @n DO
    SET @this_ID = (SELECT auctionID 
                    FROM (SELECT auctionID, @offset := @offset+1 AS rank 
                        FROM auction, (SELECT @offset:=0) r 
                        WHERE TIMESTAMPDIFF(SECOND,@curr_time,end_date)<0 AND
                              completed!=true) d
                    WHERE rank=@i);
    SET @max_bid = (SELECT maxBid FROM auction WHERE auctionID=@this_ID);
    SET @reserve = (SELECT reserve_price FROM auction WHERE auctionID=@this_ID);
    SET @seller  = (SELECT username FROM auction WHERE auctionID=@this_ID);
    SET @max_msgID = (SELECT MAX(message_id) FROM messages);
    if COALESCE(@max_msgID, '') = ''
    then SET @max_msgID = 0;
    end if;

    if @max_bid >= @reserve
    then -- auction won
        SET @buyer  = (SELECT username FROM bid WHERE auctionID=@this_ID AND 
            amount=@max_bid);
        INSERT INTO messages (message_id, to_user, from_user, send_time, subject, 
            body) VALUES
            (@max_msgID + 1, @seller, "YABE", @curr_time, "Your item sold!",
            CONCAT("Your auction ID ",@this_ID," sold for ",@max_bid," to user ",
                @buyer,"!  Thank you for using YABE."));
        INSERT INTO messages (message_id, to_user, from_user, send_time, subject,
            body) VALUES
            (@max_msgID + 2, @buyer, "YABE", @curr_time, "You won!",
            CONCAT("You won auction ID ",@this_ID," for ",
                @max_bid,"!  Thank you for using YABE."));
    else -- auction not won
        INSERT INTO messages (message_id, to_user, from_user, send_time, subject, 
            body) VALUES
            (@max_msgID + 1, @seller, "YABE", @curr_time, "Your item didn't sell :-(",
            CONCAT("Your auction ID ",@this_ID," did not reach your reserve price 
                of ",@reserve,
                ", and thus did not sell.  Thank you for using YABE."));
    end if;
    UPDATE auction SET completed=true WHERE auctionID=@this_ID;
    SET @i = @i + 1;
END WHILE;
end$$

drop event if exists end_auction_event$$
create event end_auction_event
on schedule every 1 minute
on completion preserve
do begin
call end_auction();
end$$

/*
create trigger starting_price
after insert on auction
for each row
begin
SET @max_bidID = (SELECT MAX(bidID) FROM bid);
if COALESCE(@max_bidID, '') = ''
then SET @max_bidID = 0;
end if;
INSERT INTO bid (bidID, amount, max_amount, time, username, auctionID) VALUES
(@max_bidID+1, new.start_price, 0, NOW(), "YABE", new.auctionID);
end$$
*/
delimiter ;



/*
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
*/
