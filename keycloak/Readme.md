# KeyCloak

> Study guide for Security and KeyCloack in SpringBoot applications

## Table of Contents

## What is keycloak?
Uzywany w firmach do autoryzacji i authentykacji. Jego features to:
- Single Sign-On (SSO)
- Identity Brokering and Social Login - cos typu Cognito z AWS, mozna sie logowac za pomoca zewnetrznych providerow
- User Federation - LDAP sluzy do zarzadzania/przypisywania rol do uzytkownikow pod spodem keycloaka moze byc widoczny(LDAP)
- Fine-Grained Authorization Services - decoupling & microservices atch
- Centralized Management and Admin Console
- Client Adapters
- Sdandards Based

## Advantages
- Open-source, free
- Versatility - uzywany i integrowalny z duza iloscia zewnetrznych aplikacji
- Scalability
- Security - BruteForceDetection/Password strength policies
- Customizability - it is fully customizable
- Ease of Use - zewnetrzne GUI/apka ktora latwo pozwala tymi wszystkimi rzeczami zarzadzac

## Terms

- Realm - kompletną jednostkę uwierzytelniania i autoryzacji. Każdy realm działa jako niezależna domena i zawiera własne użytkowników, role, klienty i inne konfiguracje. Można myśleć o realmie jako o oddzielnej instancji Keycloaka, w której wszystko jest izolowane od innych realmów. Dzięki temu możliwe jest zarządzanie wieloma niezależnymi środowiskami (np. dla różnych aplikacji czy klientów) w ramach jednego serwera Keycloaka.
- Clients - aplikacja, która chce się zintegrować z Keycloakiem,  Każdy klient posiada unikalne ID oraz może być skonfigurowany w zakresie uprawnień dostępu
- Client Scopes - Można je używać do grupowania uprawnień oraz zarządzania tym, jakie dane mogą być udostępniane różnym klientom. 
- Users - final users of the apps
- Groups - Groups to sposób na organizowanie użytkowników w większe jednostki, które mogą dziedziczyć wspólne role i uprawnienia. Grupowanie użytkowników pozwala na łatwiejsze zarządzanie uprawnieniami w przypadku dużych systemów z wieloma użytkownikami.


```java
 @PreAuthorize("hasRole(client_admin)")
    @GetMapping("/hello-2")
    public String hello2(){
        return "Hello from SpringBoot Keycloak - ADDDMIIIINNN";
    }
```

Jezeli w naszym programie zrobimy jakies customowe Role to moze to nie zadzialac w programie!!
Ogolnie uzywanym schematem, ktory jest zaimplementowany pod spodem w Spring Security jest: "ROLE_"


ALBO MOZNA ZROBIC KLASE KONWERTUJACA KTORA ZAMIENI TE ROLE NASZE CUSTOMOWE NA TE ODPOWIEDNIE DLA SPIRNG SECURITY

```java
public class JwtAuthConverter implements Converter<Jwt, AbstractAuthenticationToken> {

    private final JwtGrantedAuthoritiesConverter jwtGrantedAuthoritiesConverter =
            new JwtGrantedAuthoritiesConverter();

    @Value("${jwt.auth.converter.principle-attribute}")

    private String principalAttribute;
    @Value("${jwt.auth.converter.resource-id}")
    private String resourceId;

    @Override
    public AbstractAuthenticationToken convert(@NonNull Jwt jwt) {
        Set<GrantedAuthority> authorities = Stream.concat(
                jwtGrantedAuthoritiesConverter.convert(jwt).stream(),
                extractResourceRoles(jwt).stream()).collect(Collectors.toSet());
        return new JwtAuthenticationToken(
                jwt,
                authorities,
                getPrincipalClaimName(jwt)
        );
    }

    private String getPrincipalClaimName(Jwt jwt) {
        String claimName = JwtClaimNames.SUB;
        if (principalAttribute != null) {
            claimName = principalAttribute;
        }
        return jwt.getClaim(claimName);

    }

    private Collection<? extends GrantedAuthority> extractResourceRoles(Jwt jwt) {
        Map<String, Object> resourceAccess;
        Map<String, Object> resource;
        Collection<String> resourceRoles;
        if (jwt.getClaim("resource_access") == null) {
            return Set.of();
        }
        resourceAccess = jwt.getClaim("resource_access");
        if (resourceAccess.get(resourceId) == null) { //to mozna wyekstraktowac do application.yaml i w zaleznosci od srodowiska - prod/test zmieniac p
            return Set.of();
        }
        resource = (Map<String, Object>) resourceAccess.get(resourceId);
        resourceRoles = (Collection<String>) resource.get("roles");


        return resourceRoles.stream().map(role -> new SimpleGrantedAuthority("ROLE_" + role)).collect(Collectors.toSet());
    }
}
```
