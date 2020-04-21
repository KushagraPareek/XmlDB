xquery version "3.1";

declare namespace wc = "http://kush.pareek.com/wocoSchema";

let $xmlDoc := doc("woco.xml")
let $schema  := <xs:schema xmlns:wc="http://kush.pareek.com/wocoSchema" xmlns:xs="http://www.w3.org/2001/XMLSchema" 
                                        targetNamespace="http://kush.pareek.com/wocoSchema">
    
    <xs:element name="woco">
        <xs:complexType>
            <xs:sequence>
                <xs:element name="company" type="wc:companyType" minOccurs="0" maxOccurs="unbounded"/>
                <xs:element name="person" type="wc:personType" minOccurs="0" maxOccurs="unbounded"/>
                
            </xs:sequence>
        </xs:complexType> 
        
        <xs:key name="companyKey">
            <xs:selector xpath="company"/>
            <xs:field xpath="@cId"/> 
        </xs:key>
        <xs:keyref name="cownerKey" refer="wc:companyKey">
            <xs:selector xpath="company/ownership/owns"/>
            <xs:field xpath="@who"/>
        </xs:keyref>
        
        <xs:keyref name="cpownerKey" refer="wc:personKey">
            <xs:selector xpath="company/ownedby/owns"/>
            <xs:field xpath="@who"/>
        </xs:keyref>
        <xs:keyref name="cBoardKey" refer="wc:personKey">
            <xs:selector xpath="company/board/boardMember"/>
            <xs:field xpath="@member"/>
        </xs:keyref>
        
        <xs:key name="personKey">
            <xs:selector xpath="person"/>
            <xs:field xpath="@pId"/> 
        </xs:key>
        
        <xs:keyref name="pBoardKey" refer="wc:companyKey">
            <xs:selector xpath="person/boardMemberOf/companyServing"/>
            <xs:field xpath="@serve"/>
        </xs:keyref>
        
        <xs:keyref name="pownerKey" refer="wc:companyKey">
            <xs:selector xpath="person/ownership/owns"/>
            <xs:field xpath="@who"/>
        </xs:keyref>
        
    </xs:element>
    
    <xs:complexType name="companyType">
        <xs:sequence>
            <xs:element name="name" type="xs:string"/>
            <xs:element name="shares" type="xs:integer"/>
            <xs:element name="sharePrice" type="xs:integer"/>
            <xs:element name="industries">
                <xs:complexType>
                    <xs:sequence>
                        <xs:element name="industry" type="xs:string" minOccurs="0" maxOccurs="unbounded"/>
                    </xs:sequence>
                </xs:complexType>
            </xs:element>
            <xs:element name="board">
                <xs:complexType>
                    <xs:sequence>
                        <xs:element name="boardMember" type="wc:boardType" minOccurs="0" maxOccurs="unbounded"/>
                    </xs:sequence>
                </xs:complexType>
            </xs:element>
            <xs:element name="ownership" type="wc:ownerType" minOccurs="0" maxOccurs="1"/>
            <xs:element name="ownedby" type="wc:ownerType" minOccurs="0" maxOccurs="1"/>
        </xs:sequence>
        <xs:attribute name="cId" type="xs:string" use="required"/> 
    </xs:complexType>
    
    <xs:complexType name="boardType">
       <xs:attribute name="member" type="xs:string" use="required"/>
    </xs:complexType>
    
    <xs:complexType name="serveType">
        <xs:attribute name="serve" type="xs:string" use="required"/>
    </xs:complexType>
    <xs:complexType name="ownerType">
        <xs:sequence>
            <xs:element name="owns" minOccurs="0" maxOccurs="unbounded">
                <xs:complexType>
                    <xs:sequence>
                        <xs:element name="amount" type="xs:integer"/>
                    </xs:sequence>
                    <xs:attribute name="who" type="xs:string" use="required"/>
                </xs:complexType>	 
            </xs:element>
        </xs:sequence>  
    </xs:complexType>
    
    <xs:complexType name="personType">
        
        <xs:sequence>
            <xs:element name="name" type="xs:string"/>
            <xs:element name="boardMemberOf">
                <xs:complexType>
                    <xs:sequence>
                        <xs:element name="companyServing" type="wc:serveType" minOccurs="0" maxOccurs="unbounded"/>
                    </xs:sequence>
                </xs:complexType>
            </xs:element>
            <xs:element name="ownership" type="wc:ownerType" minOccurs="0" maxOccurs="1"/>
        </xs:sequence>
        <xs:attribute name="pId" type="xs:string" use="required"/> 
    </xs:complexType>
    
    
</xs:schema>

return validation:jaxv-report($xmlDoc, $schema)
