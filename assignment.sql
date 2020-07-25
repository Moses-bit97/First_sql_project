--QUESTION 1
SELECT COUNT (u_id) FROM users;  --returns the number of rows with ID as "u_id" from the users table.


--QUESTION 2
SELECT * FROM transfers;  --selects all fields from the transfers' table.
SELECT COUNT (u_id) FROM transfers  --returns the number of rows with its ID as "u_id" from the transfers' table.
WHERE send_amount_currency='CFA';  --selects all transfers with the currency CFA.


--QUESTION 3
SELECT COUNT (DISTINCT u_id) FROM transfers  --selects and returns the number of distinct values from the transfers' table.
WHERE send_amount_currency='CFA';   --selects all transfers with the currency CFA.


--QUESTION 4
SELECT COUNT (atx_id) FROM agent_transactions --returns the number of rows with its ID as "atx_id" from the agent_transactions' table.
WHERE EXTRACT (MONTH FROM when_created)=2018
GROUP BY EXTRACT (MONTH FROM when_created);  


--QUESTION 5
WITH agent_withdrawers AS
(SELECT COUNT (agent_id) AS net_withdrawers FROM agent_transactions
HAVING COUNT (amount) IN (SELECT COUNT(amount) FROM agent_transactions WHERE amount > -1
AND amount <> 0 HAVING COUNT(amount)>(SELECT COUNT(amount)
FROM agent_transactions WHERE amount < 1 AND amount <> 0)))
SELECT net_withdrawers FROM agent_withdrawers;

--QUESTION 6
SELECT COUNT(atx.amount) AS "atx volume city summary", ag.city
FROM agent_transactions AS atx LEFT OUTER JOIN agents AS ag ON atx.atx_id = ag.agent_id
WHERE atx.when_created BETWEEN NOW()::DATE-EXTRACT(DOW FROM NOW())::INTEGER-7
AND NOW()::DATE-EXTRACT(DOW FROM NOW())::INTEGER
GROUP BY ag.city;

--QUESTION 7
SELECT COUNT (atx.amount) AS "atx volume", 
COUNT (ag.city) AS "City", COUNT (ag.country) AS "Country"
FROM agent_transactions AS atx INNER JOIN agents AS ag ON
atx.atx_id = ag.agent_id
GROUP BY ag.country


--QUESTION 8
SELECT transfers.kind AS Kind, wallets.ledger_location AS Country, 
SUM (transfers.send_amount_scalar) AS Volume FROM transfers 
INNER JOIN wallets ON transfers.source_wallet_id = wallets.wallet_id 
WHERE (transfers.when_created > (NOW() - INTERVAL '1 week')) 
GROUP BY wallets.ledger_location, transfers.kind;


--QUESTION 9
SELECT COUNT(transfers.source_wallet_id) AS Unique_Senders, 
COUNT(transfer_id) AS Transaction_count, transfers.kind 
AS Transfer_Kind, wallets.ledger_location AS Country, 
SUM(transfers.send_amount_scalar) AS Volume 
FROM transfers INNER JOIN wallets ON transfers.source_wallet_id = wallets.wallet_id 
WHERE (transfers.when_created > (NOW() - INTERVAL '1 week')) 
GROUP BY wallets.ledger_location, transfers.kind;


--QUESTION 10
SELECT SUM (transfers.send_amount_scalar)
FROM transfers
JOIN wallets ON wallets.wallet_id = transfers.source_wallet_id
WHERE transfers.send_amount_scalar > 10000000 AND transfers.send_amount_currency = 'CFA'
AND transfers.when_created > CURRENT_DATE - interval '1 month';

