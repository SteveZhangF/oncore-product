<div>
<h1>${name}</h1>
<hr/>
<form>
<input type="hidden" name="tableName" value="${tableName}">
<#if fields?exists>
<#list fields as field>
<label>${field.name}
<input name="${field.name}" type="<#if field.fieldType == 'string'>text<#elseif field.fieldType=='upload'>file</#if>"/>
</label>
<br>
</#list>
</#if>
</form>
</div>




