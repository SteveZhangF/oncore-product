<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE hibernate-mapping
        PUBLIC "-//Hibernate/Hibernate Mapping DTD 3.0//EN"
        "http://www.hibernate.org/dtd//hibernate-mapping-3.0.dtd">

<hibernate-mapping>
    <class
            name="${tableName}"
            table="${tableName}"
            dynamic-update="false"
            dynamic-insert="false"
            select-before-update="false"
            optimistic-lock="version">
        <id
                name="id"
                column="ID"
                type="long"
                unsaved-value="null">
            <generator class="native"/>
        </id>
        <property name="userId"
                  type="string"
                  column="userId"/>
        <property name="deleted" type="boolean">
            <column name="deleted" not-null="false" default="false" />
        </property>
    <#if fields?exists>
        <#list fields as attr>
            <#if attr.name == "id">
            <#elseif attr.fieldType=="string">
                <property
                        name="${attr.name}"
                        type="java.lang.String"
                        update="true"
                        insert="true"
                        access="property"
                        column="${attr.name}"
                        length="${attr.length}"
                        not-null="false"
                        unique="false"
                        />
            <#elseif attr.fieldType=="">
                <property
                        name="${attr.name}"
                        type="java.lang.String"
                        update="true"
                        insert="true"
                        access="property"
                        column="${attr.name}"
                        length="${attr.length}"
                        not-null="false"
                        unique="false"
                        />
            <#elseif attr.fieldType=="upload">
                <property
                        name="${attr.name}"
                        type="java.lang.String"
                        update="true"
                        insert="true"
                        access="property"
                        column="${attr.name}"
                        length="${attr.length}"
                        not-null="false"
                        unique="false"
                        />
            <#else>
                <property
                        name="${attr.name}"
                        type="${attr.fieldType}"
                        update="true"
                        insert="true"
                        access="property"
                        column="`${attr.name}`"
                        not-null="false"
                        unique="false"
                        />

            </#if>
        </#list>
    </#if>
    </class>
</hibernate-mapping>
