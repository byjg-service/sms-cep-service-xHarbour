***************
FUNCTION MAIN()
***************
Local aRet2 := {}
Private vCEP_TEMP := space(8) , vEND_TEMP := space(50), vCID_TEMP := space(50), vUF_TEMP := space(2), vTIPO := space(1)

cls

IF Inetestaconectada()=.F.
   alert("A Busca de Endereço pelo CEP é preciso acesso a Internet, Favor verificar sua Conexão")
   Return aRet2
ENDIF

@ 02,02      SAY "CEP.....:"
@ 03,02      SAY "ENDERECO:"
@ 04,02      SAY "BAIRRO..:"
@ 05,02      SAY "CIDADE..:"
@ 06,02      SAY "UF......:"

@ 08,02      SAY "TIPO CONSULTA:   1=BUSCA PELO CEP 2=BUSCA APARTIR DO ENDERECO"

@ 02,11 GET vCEP_TEMP PICTURE "@R 99999-999"
@ 03,11 GET vEND_TEMP PICTURE "@!"
@ 05,11 GET vCID_TEMP PICTURE "@!"
@ 06,11 GET vUF_TEMP  PICTURE "!!"

@ 08,16 GET vTIPO  PICTURE "!"
READ

aRet2:=Busca_Cep3()
IF LEN(aRet2) > 0
   @ 15,02      SAY "CEP.....:" + aRet2[1]
   @ 16,02      SAY "ENDERECO:" + aRet2[2]
   @ 17,02      SAY "BAIRRO..:" + aRet2[3]
   @ 18,02      SAY "CIDADE..:" + aRet2[4]
   @ 19,02      SAY "UF......:" + ALLTRIM(aRet2[5])
ENDIF
Return Nil


*******************
Function Busca_Cep3
*******************
Local cBuf
Local aRet := {}
Local aRet3:= {}
LOCAL aTokens := {}
Local nMAXLEN := 0
Local vESCOLA
TRY
   oSoapClient := CreateObject( "MSSOAP.SoapClient" )
CATCH
   TRY
      oSoapClient := CreateObject( "MSSOAP.SoapClient" )
   CATCH
      ALERT( "Erro! Ao tentar Acessar o WEB SERVICE")
      Return aRet
   END
END

IF vTIPO="1"
   if empty(vCEP_TEMP)
      ALERT("Obrigatorio informar o Cep, Favor Revisar")
      Return aRet
   endif
ELSE
   if empty(vEND_TEMP)
      alert("Obrigatorio informar o Endereço, Favor Revisar")
      Return aRet
   endif

   if empty(vCID_TEMP)
      alert("Obrigatorio informar o Municipio, Favor Revisar")
      Return aRet
   endif

   if empty(vUF_TEMP)
      alert("Obrigatorio informar a Unidade Federativa, Favor Revisar")
      Return aRet
   endif
ENDIF

IF vTIPO="1"
   oSoapClient:msSoapInit("http://www.byjg.com.br/site/webservice.php/ws/cep?WSDL" )
   cBuf := oSoapClient:obterLogradouroAuth(vCEP_TEMP,"usuario","senha")
   oSoapClient:=Nil

   IF !LEFT(cBuf,3) = "Cep"
      aadd( aRet, vCEP_TEMP )
      aTokens := HB_ATokens( cBuf, ",", .F., .F. )
      FOR i := 1 TO Len( aTokens )
         aadd( aRet, aTokens[i] )
      NEXT
   ENDIF
ELSE
   oSoapClient:msSoapInit("http://www.byjg.com.br/site/webservice.php/ws/cep?WSDL" )
   cBuf := oSoapClient:obterCEPAuth(alltrim(vEND_TEMP),alltrim(vCID_TEMP),alltrim(vUF_TEMP),"usuario","senha")
   oSoapClient:=Nil

   IF Upper(alltrim(cBuf[1])) # "LOGRADOURO NÃO ENCONTRADO"
      IF len(cBuf:value()) > 0
         FOR x := 1 TO len(cBuf:value())
            AADD(aRet3,alltrim(cBuf[x]))
         NEXT

         IF LEN(aRet3) > 0
            AEVAL(aRet3, {|cV,nV| IF( LEN( aRet3[nV] ) > nMAXLEN,nMAXLEN := LEN( aRet3[nV] ), NIL ) })
            vESCOLA := ACHOICE(10,1,nMAXLEN,70,aret3,.T.,,vESCOLA)

            IF vESCOLA > 0
               aTokens := HB_ATokens( aret3[vESCOLA], ",", .F., .F. )
               FOR i := 1 TO Len( aTokens )
                  aadd( aRet, aTokens[i] )
               NEXT
            ENDIF
         ENDIF
      ENDIF
   ENDIF
ENDIF

if len(aRet) = 0
   alert('Nenhum Resultado encontrado')
endif
Return aRet

**************************************
Function inetestaconectada( cAddress )
**************************************
LOCAL aHosts
LOCAL cName
InetInit()
IF cAddress == NIL
   cAddress := "www.google.com.br"
ENDIF
aHosts := InetGetHosts( cAddress )
IF aHosts == NIL .or. len(aHosts)=0
   InetCleanup()
   RETURN .f.
endif
InetCleanup()
RETURN .t.
