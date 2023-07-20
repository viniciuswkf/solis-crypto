# Solis-Crypto

Solution backend for cryptocurrency withdraws as fiat currency

### Tasks:
- [x] Authentication

- [x] Deposit
    - [x] CRUD
    - [x] Coinbase integration
    - [x] Release of amounts to user

- [x] Withdrawal requests


Extra to-do:

- [ ] Change numeric id to UUID
- [ ] Improve security details
- [ ] Test all business logic

### ENDPOINTS:
```
POST /users

POST /sessions
GET /sessions

POST /deposits
GET /deposits
GET /deposits/:id
DELETE /deposits/:id

POST /withdraws
GET /withdraws
GET /withdraws/:id
DELETE /withdraws/:id
```
