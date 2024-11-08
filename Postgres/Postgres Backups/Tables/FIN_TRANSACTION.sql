DROP TABLE IF EXISTS findba.fin_transaction;

CREATE TABLE IF NOT EXISTS findba.fin_transaction
(
    transaction_id numeric(10,0) NOT NULL DEFAULT nextval('findba.s_fin_transaction'::regclass),
    ven_id numeric(10,0),
    transaction_desc character varying(4000) COLLATE pg_catalog."default" NOT NULL,
    itm_id numeric(10,0) NOT NULL,
    transaction_internal_code character varying(100) COLLATE pg_catalog."default",
    bsn_group_id numeric(10,0),
    status_code numeric(10,0),
    status_bdate date,
    transaction_date date,
    transaction_amnt numeric,
    cur_cnv_future_id numeric(10,0),
    src_customer_id numeric(10,0),
    dst_customer_id numeric(10,0),
    comments character varying(4000) COLLATE pg_catalog."default",
    creation_date timestamp with time zone NOT NULL DEFAULT now(),
    created_by numeric(10,0) NOT NULL,
    update_date date,
    updated_by numeric(10,0),
    transaction_purpose_code numeric(5,0) DEFAULT 0,
    dst_transaction_purpose_code numeric(5,0),
    dst_bsn_group_id numeric(10,0),
    last_extraction_date date,
    cur_id numeric(10,0),
    transaction_reference character varying(4000) COLLATE pg_catalog."default",
    card_id numeric(10,0),
    psycho_rule_value numeric,
    account_id numeric(10,0),
    payment_due_date date,
    subdiv_code numeric(10,0),
    cou_id numeric(10,0),
    country_region_id numeric(10,0),
    promo_prc_rl_id numeric(10,0),
    data_source numeric(5,0),
    CONSTRAINT pk_transaction PRIMARY KEY (transaction_id)
        USING INDEX TABLESPACE vcis_index,
  
    CONSTRAINT fk_trns_acc_id FOREIGN KEY (account_id)
        REFERENCES findba.fin_account_info (account_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT fk_trnsctn_cur_cnv_ftr FOREIGN KEY (cur_cnv_future_id)
        REFERENCES sdedba.ref_com_cur_cnv_future (cur_cnv_future_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT fk_trnsctn_cur_id FOREIGN KEY (cur_id)
        REFERENCES sdedba.ref_com_currency (cur_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT fk_trnsctn_dst_bsn_grp FOREIGN KEY (dst_bsn_group_id)
        REFERENCES mdmdba.mdm_bsn_unit_group (bsn_group_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT fk_trnsctn_in_src_cust_id FOREIGN KEY (initial_src_customer_id)
        REFERENCES sdedba.ref_customer (customer_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT fk_trnsctn_itm_id FOREIGN KEY (itm_id)
        REFERENCES sdedba.ref_item (itm_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT fk_trnsctn_src_cust_id FOREIGN KEY (src_customer_id)
        REFERENCES sdedba.ref_customer (customer_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT fk_trnsctn_sts_cod FOREIGN KEY (status_code)
        REFERENCES sdedba.sts_status (status_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT fk_trnsctn_ven_id FOREIGN KEY (ven_id)
        REFERENCES sdedba.ref_ven_vendor (ven_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT fk_trs_cntry_reg_id FOREIGN KEY (country_region_id)
        REFERENCES sdedba.ref_com_country_region (country_region_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT fk_trs_promo_prc_rl FOREIGN KEY (promo_prc_rl_id)
        REFERENCES csrdba.promo_prc_rl (promo_prc_rl_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT fk_trs_subdiv_cou_id FOREIGN KEY (cou_id, subdiv_code)
        REFERENCES sdedba.ref_com_country_division (cou_id, subdiv_code) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
)


****************
-- INDEX

-- Index: fin_transaction_transaction_date_idx

-- DROP INDEX IF EXISTS findba.fin_transaction_transaction_date_idx;

CREATE INDEX IF NOT EXISTS fin_transaction_transaction_date_idx
    ON findba.fin_transaction USING btree
    (transaction_date ASC NULLS LAST)
    TABLESPACE vcis_data;


-- Index: ven_itm

-- DROP INDEX IF EXISTS findba.ven_itm;

CREATE INDEX IF NOT EXISTS ven_itm
    ON findba.fin_transaction USING btree
    (ven_id ASC NULLS LAST, itm_id ASC NULLS LAST)
    TABLESPACE vcis_data;



-- Constraint: pk_transaction

-- ALTER TABLE IF EXISTS findba.fin_transaction DROP CONSTRAINT IF EXISTS pk_transaction;
/*
ALTER TABLE IF EXISTS findba.fin_transaction
    ADD CONSTRAINT pk_transaction PRIMARY KEY (transaction_id)
    USING INDEX TABLESPACE vcis_data;
*/



-- Constraint: pk_trs_edu_schl_id

-- ALTER TABLE IF EXISTS findba.fin_transaction DROP CONSTRAINT IF EXISTS pk_trs_edu_schl_id;

ALTER TABLE IF EXISTS findba.fin_transaction
    ADD CONSTRAINT pk_trs_edu_schl_id FOREIGN KEY (education_schl_id)
    REFERENCES sdedba.ref_hr_education_school (education_schl_id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION;
	
	
	
*********
-- SEQUENCE

-- SEQUENCE: findba.s_fin_transaction

-- DROP SEQUENCE IF EXISTS findba.s_fin_transaction;

CREATE SEQUENCE IF NOT EXISTS findba.s_fin_transaction
    INCREMENT 1
    START 0
    MINVALUE 0
    MAXVALUE 999999999
    CACHE 20;

ALTER SEQUENCE findba.s_fin_transaction
    OWNED BY findba.fin_transaction.transaction_id;

ALTER SEQUENCE findba.s_fin_transaction
    OWNER TO pgdba;

GRANT ALL ON SEQUENCE findba.s_fin_transaction TO pgdba;

GRANT ALL ON SEQUENCE findba.s_fin_transaction TO pgvfds;


-- 49429279

***********************************

-- VIEWS 

-- View: ssdx_eng.v_alfa

-- DROP VIEW ssdx_eng.v_alfa;

CREATE OR REPLACE VIEW ssdx_eng.v_alfa
 AS
 SELECT f.transaction_mobile_no, 			-- Not in New
    f.cur_id,
    f.transaction_desc,
    f.promo_prc_rl_id,
    f.tech_src_transaction_amnt,
    f.transaction_amnt,
    f.psycho_rule_value,
    f.settler_name,
    f.phone_no,
    i.card_no,
    f.status_code,
    a.charge_amnt
   FROM findba.fin_transaction f,
    sdedba.ref_card_info i,
    findba.fin_transaction_charge_info a
  WHERE f.card_id = i.card_id AND a.transaction_id = f.transaction_id AND f.transaction_mobile_no IS NOT NULL;

ALTER TABLE ssdx_eng.v_alfa
    OWNER TO pgdba;

GRANT ALL ON TABLE ssdx_eng.v_alfa TO pgdba;
GRANT ALL ON TABLE ssdx_eng.v_alfa TO pgvfds;



***

-- View: ssdx_eng.v_alfa_form

-- DROP VIEW ssdx_eng.v_alfa_form;

CREATE OR REPLACE VIEW ssdx_eng.v_alfa_form
 AS
 SELECT ft.transaction_id,
    ft.created_by,
    ft.creation_date
   FROM findba.fin_transaction ft,
    findba.fin_transaction_charge_info ci
  WHERE ci.transaction_id = ft.transaction_id AND ft.itm_id = (( SELECT ref_item.itm_id
           FROM sdedba.ref_item
          WHERE ref_item.kty_code = 200::numeric AND upper(ref_item.itm_name::text) = 'BILL COLLECTION'::text)) AND ft.ven_id = 1::numeric;

ALTER TABLE ssdx_eng.v_alfa_form
    OWNER TO pgdba;

GRANT ALL ON TABLE ssdx_eng.v_alfa_form TO pgdba;
GRANT ALL ON TABLE ssdx_eng.v_alfa_form TO pgvfds;

****

-- View: ssdx_eng.v_bwe_form

-- DROP VIEW ssdx_eng.v_bwe_form;

CREATE OR REPLACE VIEW ssdx_eng.v_bwe_form
 AS
 SELECT transaction_id,
    created_by,
    creation_date
   FROM findba.fin_transaction ft
  WHERE itm_id = (( SELECT ref_item.itm_id
           FROM sdedba.ref_item
          WHERE ref_item.kty_code = 200::numeric AND upper(ref_item.itm_name::text) ~~ upper('GOVERNMENT BILL COLLECTION'::text))) AND ven_id = (( SELECT ref_ven_vendor.ven_id
           FROM sdedba.ref_ven_vendor
          WHERE upper(ref_ven_vendor.ven_name::text) ~~ upper('BWE'::text))) AND status_code = 7::numeric;

ALTER TABLE ssdx_eng.v_bwe_form
    OWNER TO pgdba;

GRANT ALL ON TABLE ssdx_eng.v_bwe_form TO pgdba;
GRANT ALL ON TABLE ssdx_eng.v_bwe_form TO pgvfds;


***

-- View: ssdx_eng.v_itransafer_payout_form

-- DROP VIEW ssdx_eng.v_itransafer_payout_form;

CREATE OR REPLACE VIEW ssdx_eng.v_itransafer_payout_form
 AS
 SELECT transaction_id,
    '2'::text AS "isTrSent",
    created_by,
    creation_date
   FROM findba.fin_transaction fin
  WHERE ven_id = 6::numeric AND itm_id = 3::numeric;

ALTER TABLE ssdx_eng.v_itransafer_payout_form
    OWNER TO pgdba;

GRANT ALL ON TABLE ssdx_eng.v_itransafer_payout_form TO pgdba;
GRANT ALL ON TABLE ssdx_eng.v_itransafer_payout_form TO pgvfds;

***

-- View: ssdx_eng.v_itransafer_send_money_form

-- DROP VIEW ssdx_eng.v_itransafer_send_money_form;

CREATE OR REPLACE VIEW ssdx_eng.v_itransafer_send_money_form
 AS
 SELECT transaction_id,
    created_by,
    creation_date
   FROM findba.fin_transaction fin
  WHERE ven_id = 6::numeric AND itm_id = 3::numeric;

ALTER TABLE ssdx_eng.v_itransafer_send_money_form
    OWNER TO pgdba;

GRANT ALL ON TABLE ssdx_eng.v_itransafer_send_money_form TO pgdba;
GRANT ALL ON TABLE ssdx_eng.v_itransafer_send_money_form TO pgvfds;

***

-- View: ssdx_eng.v_mechanique_form

-- DROP VIEW ssdx_eng.v_mechanique_form;

CREATE OR REPLACE VIEW ssdx_eng.v_mechanique_form
 AS
 SELECT transaction_id,
    created_by,
    creation_date
   FROM findba.fin_transaction fin
  WHERE itm_id = (( SELECT i.itm_id
           FROM sdedba.ref_item i
          WHERE i.itm_name::text = 'MINISTRY OF FINANCE'::text AND i.kty_code = 200::numeric)) AND ven_id = (( SELECT ref_ven_vendor.ven_id
           FROM sdedba.ref_ven_vendor
          WHERE ref_ven_vendor.ven_name::text = 'MECHANIC'::text));

ALTER TABLE ssdx_eng.v_mechanique_form
    OWNER TO pgdba;

GRANT ALL ON TABLE ssdx_eng.v_mechanique_form TO pgdba;
GRANT ALL ON TABLE ssdx_eng.v_mechanique_form TO pgvfds;

*****

-- View: ssdx_eng.v_ref_sys_6024

-- DROP VIEW ssdx_eng.v_ref_sys_6024;

CREATE OR REPLACE VIEW ssdx_eng.v_ref_sys_6024
 AS
 SELECT hea_code,
    lin_code,
    lin_name,
    lin_name2,
    lin_sname,
    lin_sname2,
    lin_ordering,
    creation_date,
    created_by,
    updated_by,
    update_date,
    buisness_flag,
    showrecord
   FROM sdedba.ref_sys6024
  WHERE lin_code = ANY (ARRAY[24::numeric, 25::numeric, 26::numeric, 10::numeric]);

ALTER TABLE ssdx_eng.v_ref_sys_6024
    OWNER TO postgres;

GRANT ALL ON TABLE ssdx_eng.v_ref_sys_6024 TO pgdba;
GRANT ALL ON TABLE ssdx_eng.v_ref_sys_6024 TO pguser;
GRANT ALL ON TABLE ssdx_eng.v_ref_sys_6024 TO pgvfds;
GRANT ALL ON TABLE ssdx_eng.v_ref_sys_6024 TO postgres;

***

-- View: ssdx_eng.v_touch

-- DROP VIEW ssdx_eng.v_touch;

CREATE OR REPLACE VIEW ssdx_eng.v_touch
 AS
 SELECT f.transaction_mobile_no,			-- Not in NEW
    f.cur_id,
    f.lgcy_inv_serial_no,
    f.promo_prc_rl_id,
    f.transaction_amnt,
    f.psycho_rule_value,
    f.settler_name,
    f.phone_no,
    i.card_no,
    f.status_code
   FROM findba.fin_transaction f,
    sdedba.ref_card_info i
  WHERE f.card_id = i.card_id;

ALTER TABLE ssdx_eng.v_touch
    OWNER TO pgdba;

GRANT ALL ON TABLE ssdx_eng.v_touch TO pgdba;
GRANT ALL ON TABLE ssdx_eng.v_touch TO pgvfds;

****

-- View: ssdx_eng.v_touch_form

-- DROP VIEW ssdx_eng.v_touch_form;

CREATE OR REPLACE VIEW ssdx_eng.v_touch_form
 AS
 SELECT ft.transaction_id,
    ft.created_by,
    ft.creation_date
   FROM findba.fin_transaction ft,
    findba.fin_transaction_charge_info ci
  WHERE ci.transaction_id = ft.transaction_id AND ft.ven_id = 2::numeric;

ALTER TABLE ssdx_eng.v_touch_form
    OWNER TO pgdba;

GRANT ALL ON TABLE ssdx_eng.v_touch_form TO pgdba;
GRANT ALL ON TABLE ssdx_eng.v_touch_form TO pgvfds;

****

-- View: ssdx_eng.value

-- DROP VIEW ssdx_eng.value;

CREATE OR REPLACE VIEW ssdx_eng.value
 AS
 SELECT l.value_type_code AS value_type
   FROM sdedba.ref_com_misc_charge_interval l
     JOIN sdedba.ref_com_misc_chrg_intv_itm_ven iv ON l.misc_charge_interval_id = iv.misc_charge_interval_id
  WHERE iv.itm_id = 1::numeric AND iv.ven_id = 2::numeric AND l.cur_id = 3::numeric AND l.transaction_status_code = 4::numeric AND 5::numeric >= l.min_misc_charge_interval AND 5::numeric <= l.max_misc_charge_interval;

ALTER TABLE ssdx_eng.value
    OWNER TO pgdba;

GRANT ALL ON TABLE ssdx_eng.value TO pgdba;
GRANT ALL ON TABLE ssdx_eng.value TO pgvfds;


*****************************


-- View: findba.fin_transaction_20240925_2m

-- DROP VIEW findba.fin_transaction_20240925_2m;

CREATE OR REPLACE VIEW findba.fin_transaction_20240925_2m
 AS
 SELECT transaction_id,
    ven_id,
    transaction_desc,
    itm_id,
    transaction_internal_code,
    bsn_group_id,
    status_code,
    status_bdate,
    transaction_date,
    transaction_amnt,
    cur_cnv_future_id,
    src_customer_id,
    dst_customer_id,
    comments,
    creation_date,
    created_by,
    update_date,
    updated_by,
    security_question,
    security_answer,
    tax_value,
    tax_value_type,
    transaction_purpose_code,
    is_customer_notified,
    dst_transaction_purpose_code,
    dst_bsn_group_id,
    last_extraction_date,
    cur_id,
    external_soc_name,
    src_customer_job_desc,
    dst_customer_job_desc,
    initial_src_customer_id,
    transaction_reference,
    card_id,
    posting_failure_reason_desc,
    psycho_rule_value,
    phone_no,
    settler_name,
    job_id,
    reason_id,
    dst_reason_id,
    loan_duration,
    lgcy_approved_transaction_amnt,
    lgcy_approved_loan_duration,
    dst_card_id,
    service_code,
    lgcy_inv_serial_no,
    lgcy_con_code,
    lgcy_invoice_date,
    lgcy_phone_no_status,
    lgcy_initial_customer_name,
    is_paid,
    membership_year,
    account_id,
    lgcy_payment_type_id,
    ven_p_id,
    itm_p_id,
    tech_transaction_type,
    service_type_code,
    service_type_number,
    initial_dst_customer_name,
    funds_source_code,
    city_name,
    branch_internal_code,
    section_name,
    water_meter_nbr,
    water_cost_amount,
    maintenance_cost_amount,
    sewage_cost_amount,
    total_penalty_amount,
    currency_denomination_amount,
    penalty_discount_amount,
    tech_receipt_content,
    item_psycho_rule_value,
    lgcy_ven_transaction_code,
    tax_period_bdate,
    tax_period_edate,
    validation_nbr,
    registration_nb,
    invoice_nbr,
    schedule_nbr,
    tax_id,
    submission_nbr,
    tax_nbr,
    event_desc,
    submission_status,
    comments2,
    property_id,
    unit_no,
    soc_registration_no,
    job_registration_no,
    payment_expiry_date,
    has_vehicule_book,
    has_insurance_con,
    has_insurance_receipt,
    has_approval,
    transaction_amnt_desc,
    insurance_vignette_no,
    insurance_con_code,
    insurance_con_bdate,
    fiscal_stamp_value,
    vignette_no,
    insurance_con_end_date,
    soc_id,
    equipment_id,
    education_faculty_id,
    location_id,
    doc_no,
    doc_validation_no,
    block_no,
    transaction_mobile_no,
    settler_title,
    payment_due_date,
    subdiv_code,
    cou_id,
    country_region_id,
    tax_reduction_amount,
    penalty_reduction_amount,
    payment_year,
    delay_payment_penalty_amnt,
    delay_pay_pnalty_discount_amnt,
    schedule_year,
    schedule_nbr_desc,
    schedule_nbr_bdate,
    lgcy_request_id,
    annual_income,
    annual_charge,
    tech_receipt_no,
    education_schl_id,
    is_automatic_paid,
    vignette_delivery_place_code,
    vignette_serial_no,
    e_vignette_tracking_no,
    submission_emp_id,
    delivery_batch_code,
    e_vignette_voucher_no,
    tech_ws_initial_payment_date,
    promo_prc_rl_id,
    bank_code,
    revised_transaction_amnt,
    revised_psycho_rule_value,
    is_screening_required,
    delivery_service_desc,
    converted_cur_id,
    has_reprint_approval,
    rel_itm_id,
    itm_denomination,
    itm_price,
    itm_commision,
    voucher_no,
    purchase_reference_no,
    reprint_request_date,
    lgcy_compny_item_ven_denom_id,
    source_cur_transaction_amnt,
    source_cur_id,
    data_source,
    min_transaction_amnt,
    max_transaction_amnt,
    comments4,
    comments3,
    counter_no,
    record_no,
    first_scan_desc,
    second_scan_desc,
    first_consumption_desc,
    property_adr_desc,
    counter_charge_amnt,
    temp_renewal_sbsrptn_charge,
    mechanization_charge_amount,
    subscription_type,
    database_id,
    city_id,
    second_consumption_desc,
    add_consumption_charge_amnt,
    dst_merchan_code,
    bsn_grp_global_info_date_id,
    reduction_amnt,
    lgcy_emp_code,
    subscription_bdate,
    subscription_edate,
    wedding_list_id,
    lgcy_daily_ccv_rate,
    fresh_card_id,
    vun_number,
    receipt_type,
    vehicule_color,
    license_no,
    lgcy_transaction_charges,
    returned_charge_amnt,
    lgcy_receipt_no,
    lgcy_ven_receipt_no,
    lgcy_customer_card_nbr,
    tech_src_transaction_amnt,
    tech_total_transaction_amnt,
    tech_dst_transaction_amnt,
    tech_dst_cou_name,
    lgcy_soc_name,
    tech_total_charge_amnt,
    tech_collected_amnt_desc,
    tech_discount_amnt,
    tech_lgcy_charge_type_desc,
    equipment_number,
    transaction_type_id,
    converted_cur_transaction_amnt,
    operation_type_id,
    channel_type
   FROM findba.fin_transaction
  WHERE transaction_date > (CURRENT_DATE - 30);

ALTER TABLE findba.fin_transaction_20240925_2m
    OWNER TO pgdba;



******************************************


-- View: findba.fin_transaction_20240926_5000

-- DROP VIEW findba.fin_transaction_20240926_5000;

CREATE OR REPLACE VIEW findba.fin_transaction_20240926_5000
 AS
 SELECT transaction_id,
    ven_id,
    transaction_desc,
    itm_id,
    transaction_internal_code,
    bsn_group_id,
    status_code,
    status_bdate,
    transaction_date,
    transaction_amnt,
    cur_cnv_future_id,
    src_customer_id,
    dst_customer_id,
    comments,
    creation_date,
    created_by,
    update_date,
    updated_by,
    security_question,
    security_answer,
    tax_value,
    tax_value_type,
    transaction_purpose_code,
    is_customer_notified,
    dst_transaction_purpose_code,
    dst_bsn_group_id,
    last_extraction_date,
    cur_id,
    external_soc_name,
    src_customer_job_desc,
    dst_customer_job_desc,
    initial_src_customer_id,
    transaction_reference,
    card_id,
    posting_failure_reason_desc,
    psycho_rule_value,
    phone_no,
    settler_name,
    job_id,
    reason_id,
    dst_reason_id,
    loan_duration,
    lgcy_approved_transaction_amnt,
    lgcy_approved_loan_duration,
    dst_card_id,
    service_code,
    lgcy_inv_serial_no,
    lgcy_con_code,
    lgcy_invoice_date,
    lgcy_phone_no_status,
    lgcy_initial_customer_name,
    is_paid,
    membership_year,
    account_id,
    lgcy_payment_type_id,
    ven_p_id,
    itm_p_id,
    tech_transaction_type,
    service_type_code,
    service_type_number,
    initial_dst_customer_name,
    funds_source_code,
    city_name,
    branch_internal_code,
    section_name,
    water_meter_nbr,
    water_cost_amount,
    maintenance_cost_amount,
    sewage_cost_amount,
    total_penalty_amount,
    currency_denomination_amount,
    penalty_discount_amount,
    tech_receipt_content,
    item_psycho_rule_value,
    lgcy_ven_transaction_code,
    tax_period_bdate,
    tax_period_edate,
    validation_nbr,
    registration_nb,
    invoice_nbr,
    schedule_nbr,
    tax_id,
    submission_nbr,
    tax_nbr,
    event_desc,
    submission_status,
    comments2,
    property_id,
    unit_no,
    soc_registration_no,
    job_registration_no,
    payment_expiry_date,
    has_vehicule_book,
    has_insurance_con,
    has_insurance_receipt,
    has_approval,
    transaction_amnt_desc,
    insurance_vignette_no,
    insurance_con_code,
    insurance_con_bdate,
    fiscal_stamp_value,
    vignette_no,
    insurance_con_end_date,
    soc_id,
    equipment_id,
    education_faculty_id,
    location_id,
    doc_no,
    doc_validation_no,
    block_no,
    transaction_mobile_no,
    settler_title,
    payment_due_date,
    subdiv_code,
    cou_id,
    country_region_id,
    tax_reduction_amount,
    penalty_reduction_amount,
    payment_year,
    delay_payment_penalty_amnt,
    delay_pay_pnalty_discount_amnt,
    schedule_year,
    schedule_nbr_desc,
    schedule_nbr_bdate,
    lgcy_request_id,
    annual_income,
    annual_charge,
    tech_receipt_no,
    education_schl_id,
    is_automatic_paid,
    vignette_delivery_place_code,
    vignette_serial_no,
    e_vignette_tracking_no,
    submission_emp_id,
    delivery_batch_code,
    e_vignette_voucher_no,
    tech_ws_initial_payment_date,
    promo_prc_rl_id,
    bank_code,
    revised_transaction_amnt,
    revised_psycho_rule_value,
    is_screening_required,
    delivery_service_desc,
    converted_cur_id,
    has_reprint_approval,
    rel_itm_id,
    itm_denomination,
    itm_price,
    itm_commision,
    voucher_no,
    purchase_reference_no,
    reprint_request_date,
    lgcy_compny_item_ven_denom_id,
    source_cur_transaction_amnt,
    source_cur_id,
    data_source,
    min_transaction_amnt,
    max_transaction_amnt,
    comments4,
    comments3,
    counter_no,
    record_no,
    first_scan_desc,
    second_scan_desc,
    first_consumption_desc,
    property_adr_desc,
    counter_charge_amnt,
    temp_renewal_sbsrptn_charge,
    mechanization_charge_amount,
    subscription_type,
    database_id,
    city_id,
    second_consumption_desc,
    add_consumption_charge_amnt,
    dst_merchan_code,
    bsn_grp_global_info_date_id,
    reduction_amnt,
    lgcy_emp_code,
    subscription_bdate,
    subscription_edate,
    wedding_list_id,
    lgcy_daily_ccv_rate,
    fresh_card_id,
    vun_number,
    receipt_type,
    vehicule_color,
    license_no,
    lgcy_transaction_charges,
    returned_charge_amnt,
    lgcy_receipt_no,
    lgcy_ven_receipt_no,
    lgcy_customer_card_nbr,
    tech_src_transaction_amnt,
    tech_total_transaction_amnt,
    tech_dst_transaction_amnt,
    tech_dst_cou_name,
    lgcy_soc_name,
    tech_total_charge_amnt,
    tech_collected_amnt_desc,
    tech_discount_amnt,
    tech_lgcy_charge_type_desc,
    equipment_number,
    transaction_type_id,
    converted_cur_transaction_amnt,
    operation_type_id,
    channel_type
   FROM ( SELECT fin_transaction.transaction_id,
            fin_transaction.ven_id,
            fin_transaction.transaction_desc,
            fin_transaction.itm_id,
            fin_transaction.transaction_internal_code,
            fin_transaction.bsn_group_id,
            fin_transaction.status_code,
            fin_transaction.status_bdate,
            fin_transaction.transaction_date,
            fin_transaction.transaction_amnt,
            fin_transaction.cur_cnv_future_id,
            fin_transaction.src_customer_id,
            fin_transaction.dst_customer_id,
            fin_transaction.comments,
            fin_transaction.creation_date,
            fin_transaction.created_by,
            fin_transaction.update_date,
            fin_transaction.updated_by,
            fin_transaction.security_question,
            fin_transaction.security_answer,
            fin_transaction.tax_value,
            fin_transaction.tax_value_type,
            fin_transaction.transaction_purpose_code,
            fin_transaction.is_customer_notified,
            fin_transaction.dst_transaction_purpose_code,
            fin_transaction.dst_bsn_group_id,
            fin_transaction.last_extraction_date,
            fin_transaction.cur_id,
            fin_transaction.external_soc_name,
            fin_transaction.src_customer_job_desc,
            fin_transaction.dst_customer_job_desc,
            fin_transaction.initial_src_customer_id,
            fin_transaction.transaction_reference,
            fin_transaction.card_id,
            fin_transaction.posting_failure_reason_desc,
            fin_transaction.psycho_rule_value,
            fin_transaction.phone_no,
            fin_transaction.settler_name,
            fin_transaction.job_id,
            fin_transaction.reason_id,
            fin_transaction.dst_reason_id,
            fin_transaction.loan_duration,
            fin_transaction.lgcy_approved_transaction_amnt,
            fin_transaction.lgcy_approved_loan_duration,
            fin_transaction.dst_card_id,
            fin_transaction.service_code,
            fin_transaction.lgcy_inv_serial_no,
            fin_transaction.lgcy_con_code,
            fin_transaction.lgcy_invoice_date,
            fin_transaction.lgcy_phone_no_status,
            fin_transaction.lgcy_initial_customer_name,
            fin_transaction.is_paid,
            fin_transaction.membership_year,
            fin_transaction.account_id,
            fin_transaction.lgcy_payment_type_id,
            fin_transaction.ven_p_id,
            fin_transaction.itm_p_id,
            fin_transaction.tech_transaction_type,
            fin_transaction.service_type_code,
            fin_transaction.service_type_number,
            fin_transaction.initial_dst_customer_name,
            fin_transaction.funds_source_code,
            fin_transaction.city_name,
            fin_transaction.branch_internal_code,
            fin_transaction.section_name,
            fin_transaction.water_meter_nbr,
            fin_transaction.water_cost_amount,
            fin_transaction.maintenance_cost_amount,
            fin_transaction.sewage_cost_amount,
            fin_transaction.total_penalty_amount,
            fin_transaction.currency_denomination_amount,
            fin_transaction.penalty_discount_amount,
            fin_transaction.tech_receipt_content,
            fin_transaction.item_psycho_rule_value,
            fin_transaction.lgcy_ven_transaction_code,
            fin_transaction.tax_period_bdate,
            fin_transaction.tax_period_edate,
            fin_transaction.validation_nbr,
            fin_transaction.registration_nb,
            fin_transaction.invoice_nbr,
            fin_transaction.schedule_nbr,
            fin_transaction.tax_id,
            fin_transaction.submission_nbr,
            fin_transaction.tax_nbr,
            fin_transaction.event_desc,
            fin_transaction.submission_status,
            fin_transaction.comments2,
            fin_transaction.property_id,
            fin_transaction.unit_no,
            fin_transaction.soc_registration_no,
            fin_transaction.job_registration_no,
            fin_transaction.payment_expiry_date,
            fin_transaction.has_vehicule_book,
            fin_transaction.has_insurance_con,
            fin_transaction.has_insurance_receipt,
            fin_transaction.has_approval,
            fin_transaction.transaction_amnt_desc,
            fin_transaction.insurance_vignette_no,
            fin_transaction.insurance_con_code,
            fin_transaction.insurance_con_bdate,
            fin_transaction.fiscal_stamp_value,
            fin_transaction.vignette_no,
            fin_transaction.insurance_con_end_date,
            fin_transaction.soc_id,
            fin_transaction.equipment_id,
            fin_transaction.education_faculty_id,
            fin_transaction.location_id,
            fin_transaction.doc_no,
            fin_transaction.doc_validation_no,
            fin_transaction.block_no,
            fin_transaction.transaction_mobile_no,
            fin_transaction.settler_title,
            fin_transaction.payment_due_date,
            fin_transaction.subdiv_code,
            fin_transaction.cou_id,
            fin_transaction.country_region_id,
            fin_transaction.tax_reduction_amount,
            fin_transaction.penalty_reduction_amount,
            fin_transaction.payment_year,
            fin_transaction.delay_payment_penalty_amnt,
            fin_transaction.delay_pay_pnalty_discount_amnt,
            fin_transaction.schedule_year,
            fin_transaction.schedule_nbr_desc,
            fin_transaction.schedule_nbr_bdate,
            fin_transaction.lgcy_request_id,
            fin_transaction.annual_income,
            fin_transaction.annual_charge,
            fin_transaction.tech_receipt_no,
            fin_transaction.education_schl_id,
            fin_transaction.is_automatic_paid,
            fin_transaction.vignette_delivery_place_code,
            fin_transaction.vignette_serial_no,
            fin_transaction.e_vignette_tracking_no,
            fin_transaction.submission_emp_id,
            fin_transaction.delivery_batch_code,
            fin_transaction.e_vignette_voucher_no,
            fin_transaction.tech_ws_initial_payment_date,
            fin_transaction.promo_prc_rl_id,
            fin_transaction.bank_code,
            fin_transaction.revised_transaction_amnt,
            fin_transaction.revised_psycho_rule_value,
            fin_transaction.is_screening_required,
            fin_transaction.delivery_service_desc,
            fin_transaction.converted_cur_id,
            fin_transaction.has_reprint_approval,
            fin_transaction.rel_itm_id,
            fin_transaction.itm_denomination,
            fin_transaction.itm_price,
            fin_transaction.itm_commision,
            fin_transaction.voucher_no,
            fin_transaction.purchase_reference_no,
            fin_transaction.reprint_request_date,
            fin_transaction.lgcy_compny_item_ven_denom_id,
            fin_transaction.source_cur_transaction_amnt,
            fin_transaction.source_cur_id,
            fin_transaction.data_source,
            fin_transaction.min_transaction_amnt,
            fin_transaction.max_transaction_amnt,
            fin_transaction.comments4,
            fin_transaction.comments3,
            fin_transaction.counter_no,
            fin_transaction.record_no,
            fin_transaction.first_scan_desc,
            fin_transaction.second_scan_desc,
            fin_transaction.first_consumption_desc,
            fin_transaction.property_adr_desc,
            fin_transaction.counter_charge_amnt,
            fin_transaction.temp_renewal_sbsrptn_charge,
            fin_transaction.mechanization_charge_amount,
            fin_transaction.subscription_type,
            fin_transaction.database_id,
            fin_transaction.city_id,
            fin_transaction.second_consumption_desc,
            fin_transaction.add_consumption_charge_amnt,
            fin_transaction.dst_merchan_code,
            fin_transaction.bsn_grp_global_info_date_id,
            fin_transaction.reduction_amnt,
            fin_transaction.lgcy_emp_code,
            fin_transaction.subscription_bdate,
            fin_transaction.subscription_edate,
            fin_transaction.wedding_list_id,
            fin_transaction.lgcy_daily_ccv_rate,
            fin_transaction.fresh_card_id,
            fin_transaction.vun_number,
            fin_transaction.receipt_type,
            fin_transaction.vehicule_color,
            fin_transaction.license_no,
            fin_transaction.lgcy_transaction_charges,
            fin_transaction.returned_charge_amnt,
            fin_transaction.lgcy_receipt_no,
            fin_transaction.lgcy_ven_receipt_no,
            fin_transaction.lgcy_customer_card_nbr,
            fin_transaction.tech_src_transaction_amnt,
            fin_transaction.tech_total_transaction_amnt,
            fin_transaction.tech_dst_transaction_amnt,
            fin_transaction.tech_dst_cou_name,
            fin_transaction.lgcy_soc_name,
            fin_transaction.tech_total_charge_amnt,
            fin_transaction.tech_collected_amnt_desc,
            fin_transaction.tech_discount_amnt,
            fin_transaction.tech_lgcy_charge_type_desc,
            fin_transaction.equipment_number,
            fin_transaction.transaction_type_id,
            fin_transaction.converted_cur_transaction_amnt,
            fin_transaction.operation_type_id,
            fin_transaction.channel_type
           FROM findba.fin_transaction
          WHERE fin_transaction.ven_id = 6::numeric) unnamed_subquery
 LIMIT 5000;

ALTER TABLE findba.fin_transaction_20240926_5000
    OWNER TO pgdba;



-- View: findba.fin_transaction_view

-- DROP VIEW findba.fin_transaction_view;

CREATE OR REPLACE VIEW findba.fin_transaction_view
 AS
 SELECT transaction_id,
    initial_dst_customer_name,
    funds_source_code,
    revised_transaction_amnt,
    revised_psycho_rule_value
   FROM crosstab('
    SELECT 
        kv.TRANSACTION_ID, 
        cm.Column_Name, 
        kv.GLOBAL_INFO_VALUE
    FROM 
        FINDBA.fin_transaction_global_info kv
    JOIN 
        SSDX_TMP.TMP_COLUM_CODE cm
    ON 
        kv.GLOBAL_INFO_CODE = cm.GLOBAL_INFO_CODE
    ORDER BY 1, 2
    '::text, ' VALUES 
        (''initial_dst_customer_name''),
        (''funds_source_code''),
	    (''Revised_transaction_amnt''),
	    (''Revised_psycho_rule_value'')
	
    '::text) ct(transaction_id numeric, initial_dst_customer_name character varying, funds_source_code character varying, revised_transaction_amnt numeric, revised_psycho_rule_value numeric);

ALTER TABLE findba.fin_transaction_view
    OWNER TO pgdba;

GRANT ALL ON TABLE findba.fin_transaction_view TO pgdba;
GRANT SELECT ON TABLE findba.fin_transaction_view TO pguser;

