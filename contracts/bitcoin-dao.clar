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