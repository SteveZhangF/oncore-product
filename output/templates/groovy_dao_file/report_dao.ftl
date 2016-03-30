package groovy.${name}.${tableName};

import com.oncore.userend.groovy.ReportGBaseDao;
import groovy.sql.Sql;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;
import groovy.sql.GroovyRowResult;
import java.sql.SQLException;
import java.sql.ResultSet;
@Repository()
@Transactional
class ${name}  implements ReportGBaseDao{

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
GroovyRowResult result =  this.sql.firstRow("select ${tableName}.userId,<#list nonRelatedFields as noRelatedField >${tableName}.${noRelatedField.name}<#if noRelatedField?has_next >,</#if></#list><#if (relatedFields?size>0)>,</#if><#list relatedFields as relatedField>${relatedField.tableName}${relatedField?index}.${relatedField.field_name} as ${relatedField.name} <#if relatedField?has_next>,</#if></#list> from ${tableName}  <#list relatedFields as relatedField> join ${relatedField.tableName} ${relatedField.tableName}${relatedField?index} </#list> <#if (relatedFields?size>0)> on </#if>  <#list relatedFields as relatedField> ${relatedField.tableName}${relatedField?index}.id=${tableName}.${relatedField.name} <#if relatedField?has_next> and </#if> </#list> where ${tableName}.deleted=false and ${tableName}.id='"+id + "' and ${tableName}.userId='"+userId+"'");
return result;
}

@Override
boolean update(long id, Map params,String userId)  throws SQLException  {
String updateSql = "update ${tableName} set  <#list fields as field><#if field.name=="path"><#else>${field.name}=:${field.name}</#if><#if field?has_next>,</#if></#list>  path=null where id=:id and userId=:userId";
Map map = new HashMap();
map.put("id",id);
map.put("userId",userId);
<#list fields as field>
<#if field.name=="path">
<#else>
map.put("${field.name}",params.get("${field.name}"));
</#if>
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
//String listSql = "select * from ${tableName} where deleted=false and  userId='" + userId + "'";
String listSql = "select ${tableName}.id as id,${tableName}.userId,<#list nonRelatedFields as noRelatedField >${tableName}.${noRelatedField.name}<#if noRelatedField?has_next >,</#if></#list><#if (relatedFields?size>0)>,</#if><#list relatedFields as relatedField>${relatedField.tableName}${relatedField?index}.${relatedField.field_name} as ${relatedField.name} <#if relatedField?has_next>,</#if></#list> from ${tableName}  <#list relatedFields as relatedField> join ${relatedField.tableName} ${relatedField.tableName}${relatedField?index} </#list> <#if (relatedFields?size>0)> on </#if>  <#list relatedFields as relatedField> ${relatedField.tableName}${relatedField?index}.id=${tableName}.${relatedField.name} <#if relatedField?has_next> and </#if> </#list> where ${tableName}.deleted=false and ${tableName}.userId='"+userId+"'";

return sql.rows(listSql);
}

 @Override
    Map list(String userId, int page, int row) throws SQLException {
        String listSql = "select ${tableName}.id as id, ${tableName}.userId,<#list nonRelatedFields as noRelatedField >${tableName}.${noRelatedField.name}<#if noRelatedField?has_next >,</#if></#list><#if (relatedFields?size>0)>,</#if><#list relatedFields as relatedField>${relatedField.tableName}${relatedField?index}.${relatedField.field_name} as ${relatedField.name} <#if relatedField?has_next>,</#if></#list> from ${tableName}  <#list relatedFields as relatedField> join ${relatedField.tableName} ${relatedField.tableName}${relatedField?index} </#list> <#if (relatedFields?size>0)> on </#if>  <#list relatedFields as relatedField> ${relatedField.tableName}${relatedField?index}.id=${tableName}.${relatedField.name} <#if relatedField?has_next> and </#if> </#list> where ${tableName}.deleted=false and ${tableName}.userId='"+userId+"'";
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

   @Override
    Map getOptions(String user_id) {
        Map map = new HashMap();
        <#list relatedFields as relatedField>
        String ${relatedField.name} = "select id,${relatedField.field_name} from ${relatedField.tableName} where deleted=false and  userId='"+user_id+"'";
        List ${relatedField.name}_options = sql.rows(${relatedField.name});
        map.put('${relatedField.name}',${relatedField.name}_options);
        </#list>
        
        return map;
    }

        @Override
    String getReportURL(long id, String user_id) {
        String q = "select id, path from ${tableName} where deleted = false and userId='"+user_id+"' and id='"+id+"'";
        String  url = null;
        sql.query(q,{
            ResultSet rs ->
                if (rs.next()) url = rs.getString('path')
        })
        return url;
    }

    @Override
    boolean setReportURL(long id, String user_id,String path) {
        String q = "update ${tableName} set path = '"+path+"' where userId='"+user_id+"' and id='"+id+"'";
        return sql.executeUpdate(q);
    }
    @Override
    boolean clearPath() {
        String clp = "update ${tableName} set path=null";
        return sql.executeUpdate(clp);
    }

}
