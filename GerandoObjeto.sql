USE [FitCard_Sisatec]
GO

/****** Object:  StoredProcedure [dbo].[CRIA_TABELA_LEILAO_OS]    Script Date: 06/03/2018 13:13:20 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[GERAR_OBJETO] (@BANCO VARCHAR(100), @TABELA VARCHAR(100))
AS 
BEGIN

declare @SQL varchar(MAX)
DECLARE @table TABLE
(
   ColumnName sysname,
   ColumnId int,
   ColumnType sysname,
   NullableSign nvarchar(100)
);
declare @Result varchar(max) = 'public class ' + @TABELA + '
{'

SET @SQL = 'use ' + @BANCO + ';
		select 
        replace(col.name, '' '', ''_'') ColumnName,
        column_id ColumnId,
        case typ.name 
            when ''bigint'' then ''long''
            when ''binary'' then ''byte[]''
            when ''bit'' then ''bool''
            when ''char'' then ''string''
            when ''date'' then ''DateTime''
            when ''datetime'' then ''DateTime''
            when ''datetime2'' then ''DateTime''
            when ''datetimeoffset'' then ''DateTimeOffset''
            when ''decimal'' then ''decimal''
            when ''float'' then ''float''
            when ''image'' then ''byte[]''
            when ''int'' then ''int''
            when ''money'' then ''decimal''
            when ''nchar'' then ''string''
            when ''ntext'' then ''string''
            when ''numeric'' then ''decimal''
            when ''nvarchar'' then ''string''
            when ''real'' then ''double''
            when ''smalldatetime'' then ''DateTime''
            when ''smallint'' then ''short''
            when ''smallmoney'' then ''decimal''
            when ''text'' then ''string''
            when ''time'' then ''TimeSpan''
            when ''timestamp'' then ''DateTime''
            when ''tinyint'' then ''byte''
            when ''uniqueidentifier'' then ''Guid''
            when ''varbinary'' then ''byte[]''
            when ''varchar'' then ''string''
            else ''UNKNOWN_'' + typ.name
        end ColumnType,
        case 
            when col.is_nullable = 1 and typ.name in (''bigint'', ''bit'', ''date'', ''datetime'', ''datetime2'', ''datetimeoffset'', ''decimal'', ''float'', ''int'', ''money'', ''numeric'', ''real'', ''smalldatetime'', ''smallint'', ''smallmoney'', ''time'', ''tinyint'', ''uniqueidentifier'') 
            then ''?'' 
            else '''' 
        end NullableSign
    from  sys.columns col
        join sys.types typ on
            col.system_type_id = typ.system_type_id AND col.user_type_id = typ.user_type_id
    where object_id = object_id(''' + @TABELA + ''')'

INSERT INTO @table
EXEC (@SQL)

select @Result = @Result + '
    public ' + ColumnType + NullableSign + ' ' + ColumnName + ' { get; set; }
'
from  @table t
order by ColumnId

set @Result = @Result  + '
}'

print @Result

END


GO


