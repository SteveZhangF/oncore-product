<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page isELIgnored="false" %>
<div>
    <table id="dg_${tableName}" title="${name}" class="easyui-datagrid" style="width:700px;height:250px"
           url="entities/${tableName}/" method="get"
           toolbar="#toolbar_${tableName}" pagination="true"
           rownumbers="true" fitColumns="true" singleSelect="true">
        <thead>
        <tr>
            <th data-options="field:'id'">ID</th>
            <#list fields as field>
            <th data-options="field:'${field.name}'">${field.name}</th>
            </#list>
        </tr>
        </thead>
        <tbody>
        </tbody>
    </table>
    <div id="toolbar_${tableName}">
        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-add" plain="true" onclick="new${tableName}()">New ${name}</a>
        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-edit" plain="true" onclick="edit${tableName}()">Edit ${name}</a>
        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-remove" plain="true" onclick="destroy${tableName}()">Remove ${name}</a>
    </div>

    <div id="dlg_${tableName}" class="easyui-dialog" style="width:400px;height:280px;padding:10px 20px"
         closed="true" buttons="#dlg-buttons_${tableName}">
        <div class="ftitle">${name}</div>
        <form id="fm_${tableName}" method="post" novalidate>
            <input name="id" type="hidden">

            <#list fields as field>
                <div class="fitem">
                    <label>${field.name}:</label>
                    <input name="${field.name}" class="easyui-textbox" type='<#if field.fieldType=='upload'>file<#elseif field.fieldType=='int'>number<#elseif field.fieldType=='string'>text</#if>' <#if field.ifNull==true><#else>required</#if>>
                </div>
             
            </#list>


            <input id="fm_method_${tableName}" name="_method" type="hidden" value="post">
           
        </form>
    </div>
    <div id="dlg-buttons_${tableName}">
        <a href="javascript:void(0)" class="easyui-linkbutton c6" iconCls="icon-ok" onclick="save${tableName}()" style="width:90px">Save</a>
        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-cancel" onclick="javascript:$('#dlg_${tableName}').dialog('close')" style="width:90px">Cancel</a>
    </div>
</div>
<script>
    $('#dg_${tableName}').datagrid();
    $('#dg_${tableName}').datagrid('hideColumn','id');

    var url;
    function new${tableName}(){
        $('#dlg_${tableName}').dialog('open').dialog('center').dialog('setTitle','New ${name}');
        $('#fm_${tableName}').form('clear');
        $('#fm_method_${tableName}').val('post');
        url = 'entities/${tableName}/';
    }
    function edit${tableName}(){
        var row = $('#dg_${tableName}').datagrid('getSelected');
        if (row){
            $('#dlg_${tableName}').dialog('open').dialog('center').dialog('setTitle','Edit ${name}');
            $('#fm_${tableName}').form('load',row);
            $('#fm_method_${tableName}').val("put");
            url = 'entities/${tableName}/';
        }
    }
    function save${tableName}(){
        $('#fm_${tableName}').form('submit',{
            url: "entities/${tableName}/",
            onSubmit: function(){
                return $(this).form('validate');
            },
            success: function(result){
                $('#dlg_${tableName}').dialog('close');
                $('#dg_${tableName}').datagrid('reload');

            }
        });
    }
    function destroy${tableName}(){
        var row = $('#dg_${tableName}').datagrid('getSelected');
        if (row){
            $.messager.confirm('Confirm','Are you sure you want to destroy this ${name}?',function(r){
                if (r){

                    $.get("entities/${tableName}/delete/"+row.id,function(result){
                            $('#dg_${tableName}').datagrid('reload');    // reload the ${name} data
                    });
                }
            });
        }
    }

</script>
