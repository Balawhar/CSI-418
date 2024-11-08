

-- Add a NOT NULL referenced column

ALTER TABLE suitedba.br_business_rule_message_info
ADD COLUMN business_rule_id NUMERIC(10,0) REFERENCES suitedba.br_business_rule_definition(business_rule_id);

UPDATE suitedba.br_business_rule_message_info
SET business_rule_id = (SELECT business_rule_id 
                        FROM suitedba.br_business_rule_definition 
                        LIMIT 1)
WHERE business_rule_id IS NULL;

ALTER TABLE suitedba.br_business_rule_message_info
ALTER COLUMN business_rule_id SET NOT NULL;

******************************************************************************************

CURRENT_TIMESTAMP	-- Date & Time
now()				-- Date & Time
CURRENT_DATE		-- Date ONLY

******************************************************************************************