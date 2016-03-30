DROP TRIGGER IF EXISTS ${tableName}_update;   

create trigger ${tableName}_update after update on ${tableName} for each row

begin


end



