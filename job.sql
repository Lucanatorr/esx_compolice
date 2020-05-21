USE `essentialmode`;


INSERT INTO `jobs` (`name`, `label`) VALUES
('compolice', 'Community Police'),
('offcompolice', 'Off-Duty');

INSERT INTO `job_grades` (`job_name`, `grade`, `name`, `label`, `salary`, `skin_male`, `skin_female`) VALUES
('compolice', 0, 'officer', 'Officer', 500, '{"tshirt_1":105,"torso_1":118,"torso_2":7,"bags_1":0,"helmet_2":0,"chain_2":0,"bags_2":0,"chain_1":8,"bproof_2":4,"decals_2":0,"pants_2":8,"glasses_2":0,"arms":22,"mask_2":0,"sex":0,"shoes_2":0,"glasses_1":5,"bproof_1":10,"mask_1":128,"decals_1":0,"tshirt_2":0,"skin":0,"shoes_1":25,"pants_1":10,"helmet_1":58}', '{}'),
('offcompolice', 0, 'officer', 'Community Officer', 500, '{}', '{}');