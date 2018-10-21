insert into groups (name, variables, enabled) values('front', '{}', 1);
insert into groups (name, variables, enabled) values('backend', '{}', 1);
insert into host (host, hostname, variables, enabled) values ('172.28.128.3', 'v1', '{}', 1);
insert into host (host, hostname, variables, enabled) values ('172.28.128.4', 'v2', '{}', 1);
insert into host (host, hostname, variables, enabled) values ('172.28.128.5', 'v3', '{}', 1);
insert into hostgroups (host_id, group_id) values (1,1);
insert into hostgroups (host_id, group_id) values (2,1);
insert into hostgroups (host_id, group_id) values (3,2);

update host set variables='{\"app\":[\"httpd\"]}' where hostname='v1';
update host set variables='{\"app\":[\"httpd\", \"jboss\"]}' where hostname='v2';
update host set variables='{\"app\":[\"httpd\"]}' where hostname='v3';

