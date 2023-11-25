@actualizar
Feature: Actualizar un producto usando la API /api/v1/product/

  Background: 
    * url 'http://localhost:8081'
    * def ruta_crear = '/api/v1/product/'
    Given path ruta_crear,"/"
    And request { name: 'Iphone 99', description: 'Este es un smartphone de alta gama', price: 9999 }
    When method post
    Then status 201
    * def sku_creado = response.sku

  Scenario Outline: Actualizar un producto sin exito - 400 [Validacion de campos nulos y vacios]
    Given path ruta_crear,"/",sku_creado,"/"
    And request <producto>
    And header Accept = 'application/json'
    When method put
    Then status 400
    And match responseType == 'json'
    And match $ == {"sku":'#notnull',"status":false,"message":<message>}

    Examples: 
      | producto                                                               | message                                        |
      | { name: 'Iphone Actualizado'}                                          | "La nueva descripción no debe estar en blanco" |
      | { description: 'Descripcion Actualizada5'}                             | "El nuevo nombre no debe estar en blanco"      |
      | { price: 90000 }                                                       | "El nuevo nombre no debe estar en blanco"      |
      | { name: 'Iphone X', description: 'Descripcion Actualizada4'}           | "El nuevo precio debe ser mayor a cero"        |
      | { name: 'Iphone 11', price: 9999 }                                     | "La nueva descripción no debe estar en blanco" |
      | { description: 'Descripcion Actualizada3', price: 9999 }               | "El nuevo nombre no debe estar en blanco"      |
      | { name: 'Iphone 12', description: 'Descripcion Actualizada2',price: 0} | "El nuevo precio debe ser mayor a cero"        |
      | { name: 'Iphone 13', description: '', price: 9999 }                    | "La nueva descripción no debe estar en blanco" |
      | { name: '' , description: 'Descripcion Actualizada1', price: 9999 }    | "El nuevo nombre no debe estar en blanco"      |

  Scenario Outline: Actualizar un producto sin exito - 400 [Validacion con sku incorrecto]
    Given path ruta_crear,"/",sku_creado + "x","/"
    And request <producto>
    And header Accept = 'application/json'
    When method put
    Then status 400
    And match responseType == 'json'
    And match $ == {"sku":'#notnull',"status":false,"message":"El producto no fue encontrado"}

    Examples: 
      | producto                                                           |
      | { name: 'Nokia', description: 'Celular inteligente', price: 1200 } |

  Scenario Outline: Actualizar un producto sin exito - 404 [Validacion url incorrecta]
    Given path ruta_crear,"/",sku_creado + "x"
    And request <producto>
    And header Accept = 'application/json'
    When method put
    Then status 404
    And match responseType == 'json'
    And match $ == {"timestamp":'#notnull',"status":404,"error":"Not Found","path":'#notnull'}

    Examples: 
      | producto                                                               |
      | { name: 'Motorola', description: 'Celular inteligente', price: 1500 }  |
