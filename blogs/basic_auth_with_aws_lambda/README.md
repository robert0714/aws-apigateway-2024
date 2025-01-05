# Using Basic Authentication with AWS API Gateway and Lambda
* Reference
  * https://www.cloudmailin.com/blog/basic_auth_with_aws_lambda
## What is Basic Authentication?
At its root Basic authentication uses the Authorization header to send username:password encoded in Base64. The header for admin:password looks something like the following:
```
Authorization: Basic YWRtaW46cGFzc3dvcmQ=
```
Basic authentication sends the password in Base64 encoded form using the general HTTP authentication framework. The framework structure works as follows:

![HTTP Auth Flow](https://assets.cloudmailin.com/assets/blog/basic_auth/HTTPAuth-a168015d7dd2d475fa3e1718ba93a2a3b1d0a8a8aafb052575f8c2c520cb95b2.png)

1. The client makes a request
2. The server returns a 401 response with a WWW-Authenticate header, causing the client to issue a username and password prompt.
3. The client makes a new request with the Authorization header set.
4. Credentials are checked and the server returns either a 2xx status or 403 if the user is forbidden to access the content.

More details about the HTTP Auth scheme can be found in the [HTTP authentication](https://developer.mozilla.org/en-US/docs/Web/HTTP/Authentication) docs.  
## Configuration
* Authorizer in Rest Api   
  ![Authorizer in Rest Api](./pics/2025-01-04_230049.png)
* Authorizer in Http Api  
  * step 1    
    ![Authorizer in Http Api](./pics/2025-01-05_225541.png)  
  * step 2   
    ![Authorizer in Http Api](./pics/2025-01-05_225341.png)  
  * step 3   
    ![Authorizer in Http Api](./pics/2025-01-05_225812.png)      

## Lambda Source Code  
### CommonJS
* package.json
    ```json
    {
        "type": "commonjs"
    }
    ```
* index.cjs
    ```javascript
    exports.handler = async (event) => {
        console.log('Event:', JSON.stringify(event, null, 2));

        const token = event.authorizationToken;
        const decodedToken = decodeFromBasicAuth(token); // decode Base64
        console.log('Decoded Token:', decodedToken);

        // check Token  
        const validCredentials = 'admin:password';
        console.log('Authorization Token:', token);
        console.log('Method ARN:', event.methodArn);
        if (decodedToken === validCredentials) {
            return generatePolicy('user', 'Allow', event.methodArn);
        } else {
            return generatePolicy('user', 'Deny', event.methodArn);
        }
    };

    const decodeFromBasicAuth = (token) => {    
        token=token.replace(/^Basic /i, '');
        console.log('Token:', token);
        const decoded = Buffer.from(token, 'base64').toString('utf-8');
        const [username, password] = decoded.split(':'); 

        return username+":"+ password;
    };
    // Generating IAM Policy
    const generatePolicy = (principalId, effect, resource) => {
        const policy = {
            principalId,
            policyDocument: {
                Version: '2012-10-17',
                Statement: [
                    {
                        Action: 'execute-api:Invoke',
                        Effect: effect,
                        Resource: resource,
                    },
                ],
            },
        };
        return policy;
    };
    ```
###  ES Module
* package.json
    ```json
    {
        "type": "module"
    }
    ```
* index.mjs
    ```javascript
    console.log('Loading function');

    // main function
    export const handler = async (event) => {
        console.log('Event:', JSON.stringify(event, null, 2));

        const token = event.authorizationToken;
        const decodedToken = decodeFromBasicAuth(token); // decode Base64
        console.log('Decoded Token:', decodedToken);

        // check Token  
        const validCredentials = 'admin:password';
        console.log('Authorization Token:', token);
        console.log('Method ARN:', event.methodArn);
        if (decodedToken === validCredentials) {
            return generatePolicy('user', 'Allow', event.methodArn);
        } else {
            return generatePolicy('user', 'Deny', event.methodArn);
        }
    };

    // decode Basic Auth  
    const decodeFromBasicAuth = (token) => {
        token = token.replace(/^Basic /i, '');
        console.log('Token:', token);
        const decoded = Buffer.from(token, 'base64').toString('utf-8');
        const [username, password] = decoded.split(':');
        return `${username}:${password}`;
    };

    // Generating IAM Policy
    const generatePolicy = (principalId, effect, resource) => {
        const policy = {
            principalId,
            policyDocument: {
                Version: '2012-10-17',
                Statement: [
                    {
                        Action: 'execute-api:Invoke',
                        Effect: effect,
                        Resource: resource,
                    },
                ],
            },
        };
        return policy;
    };

    ```    