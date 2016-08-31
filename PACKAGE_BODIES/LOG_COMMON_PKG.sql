--------------------------------------------------------
--  DDL for Package Body LOG_COMMON_PKG
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "SCOTT"."LOG_COMMON_PKG" AS
  --pridej parametr

  --oznaceni verze pro LOG
  c_version constant varchar2(10) := '1.0.0';

  c_Module_Name constant varchar2(30) := 'LOG';

  -- local variables from configuration table. Changes in config table applied after restart session
  g_loglevel   number;
  g_businessid EVENT_LOG.businessid%TYPE;

  -- vrati aktualni log level
  function GetLoggingLevel return number is
  begin
    return nvl(to_number(sys_context(log_pkg.c_logging_context_name,
                                     log_pkg.c_LOG_LEVEL_ATTRIBUTE)),
               g_loglevel);
    --return v_logger_level;
  end;

  procedure ParseSessionID(p_inst_id out number,
                           p_sid     out number,
                           p_serial  out number) is
    v_sessionid varchar2(20);
  begin
    v_sessionid := dbms_session.unique_session_id;
    p_sid       := to_number(substr(v_sessionid, 1, 4), 'XXXX');
    p_serial    := to_number(substr(v_sessionid, 5, 4), 'XXXX');
    p_inst_id   := to_number(substr(v_sessionid, 10, 4), 'XXXX');
  end;

  procedure Log_Message_Body(p_modul     IN EVENT_LOG.modul%type,
                             p_typModul  in EVENT_LOG.typ_modulu%type,
                             p_message   in EVENT_LOG.text_log%type,
                             p_radek     in EVENT_LOG.ERROR_ROWS%type,
                             p_business  in EVENT_LOG.businessid%type,
                             p_log_level in EVENT_LOG.log_level%type) AS
    PRAGMA AUTONOMOUS_TRANSACTION;
    v_eventTime    EVENT_LOG.EVENT_DATE%type;
    v_apl_username EVENT_LOG.apl_username%type;
    v_module       EVENT_LOG.modul%type;
    v_action       varchar2(60); --v soucasne dobe neni vyuzivano
    v_cislo        number;
    v_cislo_chyba  EVENT_LOG.ERROR_CODE%type := 0;
    v_business     EVENT_LOG.businessid%type;
    v_inst_id      EVENT_LOG.inst_id%type;
    v_serial       EVENT_LOG.serial#%type;
    v_sid          EVENT_LOG.SID%type;
    v_log_message  varchar2(2000);
  BEGIN
    --  dbms_output.put_line(v_log_type);
    v_eventTime    := systimestamp;
    v_apl_username := userenv('CLIENT_INFO'); --aplikacni informace o session
    v_business     := p_business;
  
    --pokud nebylo jmeno modulu predano, tak ho zjistim z akt. cotextu
    if p_modul is null then
      dbms_application_info.read_module(module_name => v_module,
                                        action_name => v_action);
    else
      v_module := p_modul;
    end if;
  
    --pro chybu extrahuji cislo chyby
    v_cislo_chyba := sqlcode; --nvl(REGEXP_SUBSTR(p_message,'[[:digit:]]{5}'),0);
  
    ParseSessionID(v_inst_id, v_sid, v_serial);
  
    BEGIN
      INSERT INTO EVENT_LOG
        (ID,
         ERROR_CODE,
         TEXT_LOG,
         EVENT_DATE,
         INST_ID,
         SID,
         SERIAL#,
         APL_USERNAME,
         DB_USERID,
         MODUL,
         TYP_MODULU,
         ERROR_ROWS,
         businessid,
         LOG_LEVEL)
      VALUES
        (EVENT_LOG_SEQ.nextval,
         v_cislo_chyba,
         p_message,
         v_eventTime,
         v_inst_id,
         v_sid,
         v_serial,
         nvl(v_apl_username, sys_context('USERENV', 'OS_USER')),
         sys_context('USERENV', 'SESSION_USERID'),
         v_module,
         p_typmodul,
         p_radek,
         v_business,
         p_log_level)
      returning ID into v_cislo;
      COMMIT;
    EXCEPTION
      WHEN OTHERS THEN
        --  --pokud nastane vyjimka zde, neni dale osetrena
        ROLLBACK;
        raise;
        /*
                        sys.DBMS_SYSTEM.KSDWRT(1, 'ERROR: Original');
                        sys.DBMS_SYSTEM.KSDWRT(1, p_message);
                        sys.DBMS_SYSTEM.KSDWRT(1, 'ERROR: LOG.Log_Message_Body');
                        sys.DBMS_SYSTEM.KSDWRT(1, SQLERRM);
        */
    END;
  
  END Log_Message_Body;

  --zalogovani vyjimky do LOGu
  procedure Log_Message(p_Typ_Modul   in EVENT_LOG.typ_modulu%type, --oznaceni typu modulu
                        p_BusinessID  in EVENT_LOG.businessid%type default null, --identifikator dokladu, zadosti atd.
                        p_Debug_Error in EVENT_LOG.text_log%type default null, --debug hlaska pro logovani
                        p_modul       IN EVENT_LOG.modul%type default null,
                        p_log_level   in EVENT_LOG.log_level%type default g_loglevel) --puvodce vyjimky (modul)
  
   AS
    v_logtext EVENT_LOG.text_log%type;
    v_sqlline varchar2(32760);
    --  v_ret EVENT_LOG.id%type;
  BEGIN
    --pokud je parametr neprazdny => beru tento text misto chyby
    if p_Debug_Error is not null then
      v_logtext := substr(p_Debug_Error, 1, 2000);
      v_sqlline := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
    else
      --jinak zjistuji chybu podle DB
      v_logtext := DBMS_UTILITY.FORMAT_ERROR_STACK;
      v_sqlline := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      if length(v_sqlline) > 4000 then
        v_sqlline := substr(v_sqlline, 1, 3990) || chr(13) || chr(10) ||
                     '....';
      end if;
    end if;
    --vlastni zaznamenani udalosti do tabulky
    Log_Message_Body(p_modul     => p_modul,
                     p_TypModul  => p_Typ_Modul,
                     p_message   => v_logtext,
                     p_radek     => v_sqlline,
                     p_business  => nvl(p_BusinessID, g_BusinessID),
                     p_log_level => p_log_level);
  END Log_Message;

  --Vrati true pokud je pro soucastnou session log level DEBUG
  function isloglevelDebug return boolean is
  begin
    return bitand(GetLoggingLevel, log_pkg.LOG_LEVEL_DEBUG) > 0;
  end;

  --Vrati true pokud je pro soucastnou session log level INFO
  function isloglevelInfo return boolean is
  begin
    return bitand(GetLoggingLevel, log_pkg.LOG_LEVEL_INFO) > 0;
  end;

  --Vrati true pokud je pro soucastnou session log level API
  function isloglevelAPI return boolean is
  begin
    return bitand(GetLoggingLevel, log_pkg.LOG_LEVEL_API) > 0;
    -- return true;
  end;

  --zmeni log level pro session prislusneho CLIENT_IDENTIFIER
  procedure SetLogLevelMask(p_clientID IN t_CLIENT_IDENTIFIER default null,
                            p_mask     IN number) as
  begin
    DBMS_SESSION.set_context(namespace => log_pkg.c_logging_context_name,
                             attribute => log_pkg.c_LOG_LEVEL_ATTRIBUTE,
                             value     => to_char(p_mask),
                             username  => null,
                             client_id => nvl(p_clientID,
                                              sys_context('USERENV',
                                                          'CLIENT_IDENTIFIER')));
  end;

  /*   funkce v pripade ze p_clientID je null vygeneruje unikatni identifikator pro session,
  ktery bude prirazen do v$session.CLIENT_IDENTIFIER  */

  function SetSessionIdentifier(p_clientID in t_CLIENT_IDENTIFIER default null)
    return varchar2 is
    v_clientid t_CLIENT_IDENTIFIER;
    v_sid      number;
    v_serial   number;
    v_instid   number;
    i          number;
  begin
    v_clientid := nvl(p_clientID,
                      sys_context('USERENV', 'CLIENT_IDENTIFIER'));
    if v_clientid is null then
      v_clientid := 'SESSIONAPPID_' || dbms_session.unique_session_id;
    else
      ParseSessionID(v_instid, v_sid, v_serial);
    
      /*  select count(1) into i
             from
                  gv$session s
             where s.CLIENT_IDENTIFIER=v_clientid
               and (s.inst_id || '_' || s.sid || '_' || s.serial#) !=(v_instid || '_' || v_sid || '_' || v_serial);
      
             if i =1 then
               raise_application_error(-20001, 'Duplicate ' || v_clientid || ' CLIENT_IDENTIFIER !!!');
             end if;
      */
    end if;
    DBMS_SESSION.SET_IDENTIFIER(v_clientid);
  
    return v_clientid;
  end;

  --vraci verzi package
  function GetVersion return varchar2 as
  begin
    return c_version;
  end GetVersion;

  procedure debug_message(p_Typ_Modul  in EVENT_LOG.typ_modulu%type default 'DB', --oznaceni typu modulu
                          p_modul      IN EVENT_LOG.modul%type default null, --puvodce vyjimky (modul)
                          p_BusinessID in EVENT_LOG.businessid%type default null, --identifikator dokladu, zadosti atd.
                          p_message    in EVENT_LOG.text_log%type --debug hlaska pro logovani
                          ) is
  begin
    if isLogLevelDebug then
      Log_Message(p_typ_modul   => p_typ_modul,
                  p_BusinessID  => p_Businessid,
                  p_Debug_Error => p_message,
                  p_modul       => p_modul,
                  p_log_level   => log_pkg.LOG_LEVEL_DEBUG);
    end if;
  end;

  procedure info_message(p_Typ_Modul  in EVENT_LOG.typ_modulu%type default 'DB', --oznaceni typu modulu
                         p_modul      IN EVENT_LOG.modul%type default null,
                         p_BusinessID in EVENT_LOG.businessid%type default null, --identifikator dokladu, zadosti atd.
                         p_message    in EVENT_LOG.text_log%type --debug hlaska pro logovani
                         ) is
  begin
    if isLogLevelInfo then
      Log_Message(p_typ_modul   => p_typ_modul,
                  p_BusinessID  => p_Businessid,
                  p_Debug_Error => p_message,
                  p_modul       => p_modul,
                  p_log_level   => log_pkg.LOG_LEVEL_INFO);
    end if;
  end;

  procedure api_message(p_Typ_Modul  in EVENT_LOG.typ_modulu%type default 'DB', --oznaceni typu modulu
                        p_modul      IN EVENT_LOG.modul%type default null,
                        p_BusinessID in EVENT_LOG.businessid%type default null, --identifikator dokladu, zadosti atd.
                        p_message    in EVENT_LOG.text_log%type --debug hlaska pro logovani
                        ) is
  begin
    if isLogLevelAPI then
      Log_Message(p_typ_modul   => p_typ_modul,
                  p_BusinessID  => p_Businessid,
                  p_Debug_Error => p_message,
                  p_modul       => p_modul,
                  p_log_level   => log_pkg.LOG_LEVEL_API);
    end if;
  end;

  procedure error_message(p_Typ_Modul  in EVENT_LOG.typ_modulu%type default 'DB', --oznaceni typu modulu
                          p_modul      IN EVENT_LOG.modul%type default null,
                          p_BusinessID in EVENT_LOG.businessid%type default null, --identifikator dokladu, zadosti atd.
                          p_message    in EVENT_LOG.text_log%type default null --debug hlaska pro logovani
                          ) is
  begin
    Log_Message(p_typ_modul   => p_typ_modul,
                p_BusinessID  => p_Businessid,
                p_Debug_Error => p_message,
                p_modul       => p_modul,
                p_log_level   => log_pkg.LOG_LEVEL_ERROR);
  end;

  procedure SetDefaults is
  begin
    for cur in (select distinct b.parameter,
                                first_value(b.value) over(partition by parameter order by b.pref) value
                  from (
                        -- konfigurace pro aplikaci
                        select 1 pref, PARAMETER, VALUE
                          from PARAMETERS
                         where APP_NAME = user
                           and module_name = c_Module_Name
                        union all
                        -- default konfigurace
                        select 2 pref, PARAMETER, VALUE
                          from PARAMETERS
                         where APP_NAME = '*'
                           and module_name = c_Module_Name) b) loop
      if cur.parameter = 'LOGLEVEL' then
        g_loglevel := getloglevelnum(cur.value);
      elsif cur.parameter = 'TRACEFILE_IDENTIFIER' then
        execute immediate 'alter session set tracefile_identifier =' ||
                          cur.value;
      else
        null;
      end if;
    end loop;
  end;

  procedure SetLogSessionAttribute(p_attribute in VARCHAR2,
                                   p_value     IN VARCHAR2,
                                   p_clientID  IN t_CLIENT_IDENTIFIER default null) as
    l_value VARCHAR2(50);
  begin
    if p_attribute = log_pkg.c_LOG_LEVEL_ATTRIBUTE then
      l_value := to_char(getloglevelnum(p_value));
    elsif p_attribute = log_pkg.c_TYPE_LOG_ATTRIBUTE then
      l_value := trim(upper(p_value));
      if l_value not in ('DB', 'FILE') then
        raise_application_Error(-20102,
                                'Neznamy hotnota atributu ' ||
                                log_pkg.c_TYPE_LOG_ATTRIBUTE || ' !');
      end if;
    else
      raise_application_Error(-20102, 'Neznamy atribut kontextu !');
    end if;
  
    DBMS_SESSION.set_context(namespace => log_pkg.c_logging_context_name,
                             attribute => upper(trim(p_attribute)),
                             value     => l_value,
                             username  => null,
                             client_id => nvl(p_clientID,
                                              sys_context('USERENV',
                                                          'CLIENT_IDENTIFIER')));
  end;

  procedure SetLogParameter(p_parameter in parameters.PARAMETER%type,
                            p_value     in parameters.VALUE%type,
                            p_app_name  in parameters.APP_NAME%type default user) is
    PRAGMA AUTONOMOUS_TRANSACTION;
  begin
    update parameters
       set value = p_value
     where app_name = user
       and parameter = p_parameter
       and module_name = c_Module_Name;
  
    if sql%rowcount = 0 then
      insert into parameters
        (module_name, app_name, parameter, value)
      values
        (c_Module_Name, user, p_parameter, p_value);
    end if;
  
    commit;
  exception
    when others then
      rollback;
      raise;
  end;

  function GetLogLevelNum(p_log_level in VARCHAR2) return number is
    l_tablen       BINARY_INTEGER;
    l_tab          DBMS_UTILITY.uncl_array;
    l_log_level    number;
    l_log_level_v2 VARCHAR2(300);
    n              number;
  
    FUNCTION BITOR(x IN NUMBER, y IN NUMBER) RETURN NUMBER AS
    BEGIN
      RETURN(x + y - BITAND(x, y));
    END;
  
  begin
    l_log_level_v2 := upper(trim(p_log_level));
    l_log_level    := 0;
  
    DBMS_UTILITY.comma_to_table(list   => l_log_level_v2,
                                tablen => l_tablen,
                                tab    => l_tab);
  
    FOR i IN 1 .. l_tablen loop
      n := case
             when l_tab(i) = 'INFO' then
              log_pkg.LOG_LEVEL_INFO + log_pkg.LOG_LEVEL_API
             when l_tab(i) = 'API' then
              log_pkg.LOG_LEVEL_API
             when l_tab(i) = 'DEBUG' then
              log_pkg.LOG_LEVEL_DEBUG + log_pkg.LOG_LEVEL_API + log_pkg.LOG_LEVEL_INFO
             when l_tab(i) = 'ERROR' then
              log_pkg.LOG_LEVEL_ERROR
             when l_tab(i) = 'ALL' then
              log_pkg.LOG_LEVEL_ALL
             else
              0
           end;
    
      if n = 0 then
        raise_application_error(-20101,
                                'Neznamy LOGLEVEL ' || l_tab(i) || '!');
      end if;
    
      l_log_level := BITOR(l_log_level, n);
    
      if n = log_pkg.LOG_LEVEL_ALL then
        l_log_level := log_pkg.LOG_LEVEL_ALL;
        exit;
      end if;
    end loop;
  
    return l_log_level;
  end;

  procedure PurgeLog(p_date in date) is
  begin
    -- Delete events
    Delete from EVENT_LOG
     where EVENT_DATE < p_date
       and log_level in (1, --INFO
                         8, --DEBUG
                         4 --ERROR
                         );
  exception
    when others then
      rollback;
      error_message(p_modul => 'LOG');
  end;

  procedure SetBusinessID(p_businessid in varchar2) is
  begin
    g_businessid := p_businessid;
  end;

begin
  SetDefaults;
END LOG_COMMON_PKG;

/
