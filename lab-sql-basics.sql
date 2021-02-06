
#1. Get the id values of the first 5 clients from district_id with a value equals to 1.
SELECT client_id, district_id 
FROM bank.client
WHERE district_id = 1
ORDER BY client_id ASC
LIMIT 5;

#2. In the client table, get an id value of the last client where the district_id equals to 72.
SELECT client_id, district_id
FROM bank.client
WHERE district_id = 72;


#3. In the client table, get an id value of the last client where the district_id equals to 72.
SELECT client_id, district_id
FROM bank.client
WHERE district_id = 72
ORDER BY client_id desc
LIMIT 1;

#4 Get the 3 lowest amounts in the loan table.
SELECT loan.amount
FROM bank.loan
ORDER BY amount asc
LIMIT 3;

#5 What are the possible values for status, ordered alphabetically in ascending order in the loan table?
SELECT distinct loan.status
FROM bank.loan
ORDER BY status asc;

#5. What is the loan_id of the highest payment received in the loan table?
SELECT loan.loan_id, payments
FROM bank.loan
ORDER BY payments desc
LIMIT 1;

#6. What is the loan amount of the lowest 5 account_ids in the loan table? 
#Show the account_id and the corresponding amount

SELECT loan.account_id, loan.amount
FROM bank.loan
ORDER BY account_id ASC
LIMIT 5;



#7. What are the account_ids with the lowest loan amount that have a loan duration of 60 in the loan table?
SELECT loan.account_id, loan.amount
FROM bank.loan
WHERE duration = 60
ORDER BY amount asc
LIMIT 5;


#8. What are the unique values of k_symbol in the order table?
# Note: No table name order, since order is reserved from the ORDER BY clause. 
# You have to use backticks to escape the order table name.
SELECT distinct k_symbol
FROM bank.order
ORDER BY k_symbol ASC;

#9 In the order table, what are the order_ids of the client with the account_id 34?
SELECT order_id
FROM bank.order
WHERE account_id = 34;


#10 In the order table, which account_ids were responsible for orders 
#between order_id 29540 and order_id 29560 (inclusive)?
select distinct account_id
from bank.order
where order_id between 29540 and 29560;

#11 Order table, what are the individual amounts that were sent to (account_to) id 30067122?
select amount
from bank.order
where account_to = 30067122;

#12. Trans table, show the trans_id, date, type and amount of the 10 first transactions from account_id 793 in chronological order, from newest to oldest.
select trans.trans_id, trans.date, trans.type, trans.amount
FROM bank.trans
WHERE trans.account_id = 793
ORDER BY trans.date DESC
LIMIT 10;

#13 client table, of all districts with a district_id lower than 10, how many clients are from each district_id? 
#Show the results sorted by the district_id in ascending order. 
SELECT client.district_id,  count((client.client_id)) as client_count
FROM bank.client
WHERE client.district_id < 10
GROUP BY client.district_id
ORDER BY client.district_id ASC;

#14 In the card table, how many cards exist for each type? Rank the result starting with the most frequent type.
SELECT card.type, count(card.issued) as frequency
FROM bank.card
GROUP by card.type
ORDER BY count(card.issued) DESC;

#15 Loan table, print the top 10 account_ids based on the sum of all of their loan amounts.
SELECT loan.account_id, loan.amount 
FROM bank.loan
GROUP by loan.account_id
ORDER BY SUM(loan.amount) DESC
LIMIT 10;


#16 loan table, retrieve the number of loans issued for each day,
# before (excl) 930907, ordered by date in descending order.
SELECT loan.date, count(loan_id) as number_of_loans
FROM bank.loan
WHERE date <930907
GROUP by date
ORDER BY date DESC;


#17 Loan table, for each day in December 1997, 
# count the number of loans issued for each unique loan duration, ordered by date and duration, both in ascending order. 
#You can ignore days without any loans in your output.
 
SELECT loan.date, loan.duration, count(loan.duration) as loans_issued
FROM bank.loan
where date regexp '^9712'
GROUP BY date, duration
ORDER BY date, duration ASC;


#18 Trans table, for account_id 396, sum the amount of transactions for each type (VYDAJ = Outgoing, PRIJEM = Incoming). 
# account_id, the type and the sum of amount, named as total_amount.
# Sort alphabetically by type.
SELECT trans.account_id, trans.type, round(sum(trans.amount),2) as total_amount
FROM bank.trans
WHERE trans.account_id = 396
group by trans.type
ORDER BY type ASC;

#19 Translate the values for type to English, 
#Rename the column to transaction_type, round total_amount down to an integer
SELECT trans.account_id, FLOOR(sum(trans.amount)) as total_amount,
CASE
when type = 'PRIJEM' then 'INCOMING'
when type = 'VYDAJ' then 'OUTGOING'
end as 'transaction_type'
FROM bank.trans
WHERE trans.account_id = 396
group by trans.type
ORDER BY type ASC;


#20 modify your query so that it returns only one row, with a column for incoming amount, 
# outgoing amount and the difference.
Select '396' as id, outgoing, incoming,  outgoing - incoming as diff from
(Select (Select floor(sum(amount)) as soma
from trans
where account_id=396 and type='PRIJEM'
group by type) as 'outgoing',
(Select floor(sum(amount))
from trans
where account_id=396 and type='VYDAJ'
group by type) as 'incoming') as T;

#21 Continuing with the previous example, rank the top 10 account_ids based on their difference.
Select account_id, outgoing, incoming,  outgoing - incoming as diff from
(Select (Select floor(sum(amount)) as soma
from trans
where type='PRIJEM'
group by type
order by account_id as desc
limit 10) as 'outgoing',
(Select floor(sum(amount))
from trans
where type='VYDAJ'
group by type
order by account_id as desc
limit 10) as 'incoming') as T;

