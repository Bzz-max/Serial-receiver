# Serial-receiver
This project implements a serial receiver using a finite state machine (FSM). The module receives one bit per clock cycle, stores the data internally, and asserts a done signal when a full byte has been successfully received. 
The receiver monitors a serial input line and processes incoming data using a five-state FSM:
1. IDLE – Waits for the start of a transmission
2. START – Detects the start condition
3. RECEIVE – Collects 8 serial bits into a register
4. WAIT – Handles invalid or incomplete transmissions
5. STOP – Signals successful reception of one byte <br>
Once 8 bits are received, the module asserts done for one clock cycle and presents the received byte on the output.

