;; Title: Bitcoin-Powered Decentralized Autonomous Organization (DAO)
;; Summary: A comprehensive smart contract system for decentralized governance and treasury management
;; Description:
;; This contract implements a full-featured DAO ecosystem leveraging Bitcoin's security through the Stacks blockchain.
;; Key features include:
;; - Membership management with staking mechanism
;; - Proposal lifecycle management (creation, voting, execution)
;; - Treasury management with transparent fund allocation
;; - Reputation-based governance system with activity incentives
;; - Cross-DAO collaboration framework
;; - Inactivity decay mechanism to maintain governance participation
;; - Bitcoin-native asset (STX) integration for transactions and governance

;; Constants
(define-constant CONTRACT-OWNER tx-sender)
(define-constant ERR-NOT-AUTHORIZED (err u100))
(define-constant ERR-ALREADY-MEMBER (err u101))
(define-constant ERR-NOT-MEMBER (err u102))
(define-constant ERR-INVALID-PROPOSAL (err u103))
(define-constant ERR-PROPOSAL-EXPIRED (err u104))
(define-constant ERR-ALREADY-VOTED (err u105))
(define-constant ERR-INSUFFICIENT-FUNDS (err u106))
(define-constant ERR-INVALID-AMOUNT (err u107))

;; Data variables
(define-data-var total-members uint u0)
(define-data-var total-proposals uint u0)
(define-data-var treasury-balance uint u0)

;; Data maps
(define-map members principal 
  {
    reputation: uint,
    stake: uint,
    last-interaction: uint
  }
)

(define-map proposals uint 
  {
    creator: principal,
    title: (string-ascii 50),
    description: (string-utf8 500),
    amount: uint,
    yes-votes: uint,
    no-votes: uint,
    status: (string-ascii 10),
    created-at: uint,
    expires-at: uint
  }
)

(define-map votes {proposal-id: uint, voter: principal} bool)

(define-map collaborations uint 
  {
    partner-dao: principal,
    proposal-id: uint,
    status: (string-ascii 10)
  }
)

;; Private functions

(define-private (is-member (user principal))
  (match (map-get? members user)
    member-data true
    false
  )
)

(define-private (is-active-proposal (proposal-id uint))
  (match (map-get? proposals proposal-id)
    proposal (and 
      (< block-height (get expires-at proposal))
      (is-eq (get status proposal) "active")
    )
    false
  )
)

(define-private (is-valid-proposal-id (proposal-id uint))
  (match (map-get? proposals proposal-id)
    proposal true
    false
  )
)

(define-private (is-valid-collaboration-id (collaboration-id uint))
  (match (map-get? collaborations collaboration-id)
    collaboration true
    false
  )
)

(define-private (calculate-voting-power (user principal))
  (let (
    (member-data (unwrap! (map-get? members user) u0))
    (reputation (get reputation member-data))
    (stake (get stake member-data))
  )
    (+ (* reputation u10) stake)
  )
)

(define-private (update-member-reputation (user principal) (change int))
  (match (map-get? members user)
    member-data 
    (let (
      (new-reputation (to-uint (+ (to-int (get reputation member-data)) change)))
      (updated-data (merge member-data {reputation: new-reputation, last-interaction: block-height}))
    )
      (map-set members user updated-data)
      (ok new-reputation)
    )
    ERR-NOT-MEMBER
  )
)