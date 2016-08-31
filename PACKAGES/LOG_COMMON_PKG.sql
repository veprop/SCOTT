--------------------------------------------------------
--  DDL for Package LOG_COMMON_PKG
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "SCOTT"."LOG_COMMON_PKG" AS
  --scpecifikace zaznamu pro logovani parametru

  subtype t_CLIENT_IDENTIFIER is varchar2(64); -- gv$session.CLIENT_IDENTIFIER%type

  --zalogovani debug vyjimky do LOGu
  procedure debug_message(p_Typ_Modul  in EVENT_LOG.typ_modulu%type default 'DB', --oznaceni typu modulu
                          p_modul      IN EVENT_LOG.modul%type default null, --puvodce vyjimky (modul)
                          p_BusinessID in EVENT_LOG.businessid%type default null, --identifikator dokladu, zadosti atd.
                          p_message    in EVENT_LOG.text_log%type --debug hlaska pro logovani
                          );

  --zalogovani info zpravy do LOGu
  procedure info_message(p_Typ_Modul  in EVENT_LOG.typ_modulu%type default 'DB', --oznaceni typu modulu
                         p_modul      IN EVENT_LOG.modul%type default null,
                         p_BusinessID in EVENT_LOG.businessid%type default null, --identifikator dokladu, zadosti atd.
                         p_message    in EVENT_LOG.text_log%type --debug hlaska pro logovani
                         );

  --zalogovani API message do LOGu
  procedure api_message(p_Typ_Modul  in EVENT_LOG.typ_modulu%type default 'DB', --oznaceni typu modulu
                        p_modul      IN EVENT_LOG.modul%type default null,
                        p_BusinessID in EVENT_LOG.businessid%type default null, --identifikator dokladu, zadosti atd.
                        p_message    in EVENT_LOG.text_log%type --debug hlaska pro logovani
                        );

  --zalogovani chybove zpravy
  procedure error_message(p_Typ_Modul  in EVENT_LOG.typ_modulu%type default 'DB', --oznaceni typu modulu
                          p_modul      IN EVENT_LOG.modul%type default null,
                          p_BusinessID in EVENT_LOG.businessid%type default null, --identifikator dokladu, zadosti atd.
                          p_message    in EVENT_LOG.text_log%type default null --debug hlaska pro logovani
                          );

  function GetLoggingLevel return number;

  function isloglevelDebug return boolean;

  function isloglevelInfo return boolean;

  function isloglevelAPI return boolean;

  procedure SetLogLevelMask(p_clientID IN t_CLIENT_IDENTIFIER default null,
                            p_mask     IN number);

  function SetSessionIdentifier(p_clientID in t_CLIENT_IDENTIFIER default null)
    return varchar2;

  function GetVersion return varchar2;

  procedure SetLogSessionAttribute(p_attribute in VARCHAR2,
                                   p_value     IN VARCHAR2,
                                   p_clientID  IN t_CLIENT_IDENTIFIER default null);

  procedure SetLogParameter(p_parameter in parameters.PARAMETER%type,
                            p_value     in parameters.VALUE%type,
                            p_app_name  in parameters.APP_NAME%type default user);

  function GetLogLevelNum(p_log_level in VARCHAR2) return number;

  procedure PurgeLog(p_date in date);

  procedure SetBusinessID(p_businessid in varchar2);

END LOG_COMMON_PKG;

/
