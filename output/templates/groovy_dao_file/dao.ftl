package groovy.${name}.${tableName};

import com.oncore.userend.groovy.GBaseDao;
import groovy.sql.Sql;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;
import groovy.sql.GroovyRowResult;
import java.sql.SQLException;
import java.sql.ResultSet;

@Repository()
@Transactional
class ${name} implements GBaseDao{

@Autowired Sql sql;
@Override
long insert( Map params,String userId) throws SQLException {
String insert = "insert into ${tableName} (<#list fields as field>${field.name}<#if field?has_next>,</#if></#list><#if (fields?size>0) >,</#if>userId,deleted) values(<#list fields as field>:${field.name}<#if field?has_next>,</#if></#list><#if (fields?size>0) >,</#if>:userId,false)";
Map map = new HashMap();
<#list fields as field>
map.put("${field.name}",params.get("${field.name}"));
</#list>
map.put("userId",userId);
List list = this.sql.executeInsert(map, insert);
return list.get(0).get(0);
}
@Override
Map get(long id,String userId)  throws SQLException {
GroovyRowResult result =  this.sql.firstRow("select id,<#list fields as field>${field.name}<#if field?has_next>,</#if></#list><#if (fields?size>0) >,</#if>userId from ${tableName} where deleted=false and id='"+id + "' and userId='"+userId+"'");
return result;
}
@Override
boolean update(long id, Map params,String userId)  throws SQLException  {
String updateSql = "update ${tableName} set  <#list fields as field>${field.name}=:${field.name}<#if field?has_next>,</#if></#list>  where id=:id and userId=:userId";
Map map = new HashMap();
map.put("id",id);
map.put("userId",userId);
<#list fields as field>
map.put("${field.name}",params.get("${field.name}"));
</#list>
return this.sql.executeUpdate(map,updateSql)
}

@Override
boolean delete(long id,String userId)  throws SQLException  {
String deleteSql = "update ${tableName} set deleted=true where userId=:userId and id =:id";
Map map = new HashMap();
map.put("id",id);
map.put("userId",userId);
return this.sql.executeUpdate(map,deleteSql);
}
@Override
List list(String userId)  throws SQLException {
String listSql = "select id,<#list fields as field>${field.name}<#if field?has_next>,</#if></#list><#if (fields?size>0) >,</#if>userId from ${tableName} where deleted=false and  userId='" + userId + "'";
return sql.rows(listSql);
}

    @Override
    Map list(String userId, int page, int row) throws SQLException {
        String listSql = "select id,<#list fields as field>${field.name}<#if field?has_next>,</#if></#list><#if (fields?size>0) >,</#if>userId from ${tableName}  where deleted=false and  userId='" + userId + "'";
        String countSQL = "select count(id) from ${tableName} where deleted=false and  userId='" + userId + "'";
        int count;
        sql.query(countSQL, { ResultSet rs ->
            while (rs.next()) count = rs.getInt('count(id)')
        });
        List list = sql.rows(listSql,(page-1)*row,row);
        Map map = new HashMap();
        map.put("total",count);
        map.put("rows",list)
        return map;
    }
}
