/************************************************************************
 * WARNING: DO NOT EDIT THIS FILE.  THIS FILE WAS AUTOMATICALLY GENERATED
 * FROM ../alpha-emulator/ihalt.as. ANY CHANGES MADE TO THIS FILE WILL BE LOST
 ************************************************************************/

/* This file implements the out-of-line parts of the instruction dispatch loop. */
.globl SUSPENDMACHINE
.globl ILLEGALINSTRUCTION
.globl HALTMACHINE
.align 5
.globl iOutOfLine
.ent iOutOfLine 0
.align 3
iOutOfLine:
.align 3
TRAPORSUSPENDMACHINE:	# Here when someone wants the emulator to trap or stop.
        ldl	$4, PROCESSORSTATE_CONTROL($14)	#  [1]
        stq	$12, PROCESSORSTATE_RESTARTSP($14)	# Be sure this is up-to-date [1]
        ldq_l	$0, PROCESSORSTATE_PLEASE_STOP($14)	# Has the spy asked us to stop or trap? [1]
        bis	$31, $31, $5 	# [0di]
        stq_c	$5, PROCESSORSTATE_PLEASE_STOP($14)	#  [1-]
        beq	$5, COLLISION	# [1]
        stq	$31, PROCESSORSTATE_STOP_INTERPRETER($14)	#  [1]
COLLISION:
        cmpbge	$0, HaltReasonIllInstn, $3 	# t3<0>=1 if we've been asked to stop [0di]
        blbs	$3, SUSPENDMACHINE	# [1]
/* Here when someone wants the emulator to trap. */
        extll	$0, 4, $0 	# Extract PROCESSORSTATE_PLEASE_TRAP (ivory) [0di]
        srl	$4, 30, $4 	# Isolate current trap mode [1]
        cmpeq	$0, TrapReasonHighPrioritySequenceBreak, $3 	# [1]
.align 3
G15999:
        beq	$3, G15995	# [1]
/* Here if argument TrapReasonHighPrioritySequenceBreak */
        cmpule	$4, TrapModeExtraStack, $4 	# Only interrupts EXTRA-STACK and EMULATOR [0di]
        beq	$4, CONTINUECURRENTINSTRUCTION	# [1]
	br	$31, HIGHPRIORITYSEQUENCEBREAK
.align 3
G15995:
        cmpeq	$0, TrapReasonLowPrioritySequenceBreak, $3 	# [1-]
.align 3
G16000:
        beq	$3, G15996	# [1]
/* Here if argument TrapReasonLowPrioritySequenceBreak */
        bne	$4, CONTINUECURRENTINSTRUCTION	# Only interrupts EMULATOR [1]
	br	$31, LOWPRIORITYSEQUENCEBREAK
.align 3
G15996:
/* Here for all other cases */
/* Check for preempt-request trap */
        ldl	$5, PROCESSORSTATE_INTERRUPTREG($14)	# Get the preempt-pending bit [1-]
        bne	$4, CONTINUECURRENTINSTRUCTION	# Don't take preempt trap unless in emulator mode [0di]
        blbc	$5, CONTINUECURRENTINSTRUCTION	# Jump if preempt request not pending [3]
	br	$31, PREEMPTREQUESTTRAP
.align 3
G15994:
.align 3
SUSPENDMACHINE:	# Here when someone wants to stop the emulator.
        extll	$0, 0, $1 	# Get the reason [1-]
        br	$31, STOPINTERP	# [0di]
.align 3
ILLEGALINSTRUCTION:	# Here if we detect an illegal instruction.
        bis	$31, HaltReasonIllInstn, $1 	# [1-]
        br	$31, STOPINTERP	# [0di]
.align 3
HALTMACHINE:	# Here to halt machine
        bis	$31, HaltReasonHalted, $1 	# [1-]
        br	$31, STOPINTERP	# [0di]
.align 3
FATALSTACKOVERFLOW:	# Here if we detected a fatal stack overflow
        bis	$31, HaltReasonFatalStackOverflow, $1 	# [1-]
        br	$31, STOPINTERP	# [0di]
.align 3
ILLEGALTRAPVECTOR:	# Here if we detected a non-PC in a trap vector
        bis	$31, HaltReasonIllegalTrapVector, $1 	# [1-]
        br	$31, STOPINTERP	# [0di]
.align 3
STOPINTERP:
        bis	$1, $31, $0 	# Return the halt reason [1-]
        stl	$31, PROCESSORSTATE_PLEASE_STOP($14)	# Clear the request flag [0di]
        stq	$13, PROCESSORSTATE_CP($14)	#  [1]
        stq	$9, PROCESSORSTATE_EPC($14)	#  [1]
        stq	$12, PROCESSORSTATE_SP($14)	#  [1]
        stq	$10, PROCESSORSTATE_FP($14)	#  [1]
        stq	$11, PROCESSORSTATE_LP($14)	#  [1]
        stq	$31, PROCESSORSTATE_RUNNINGP($14)	# Stop the (emulated) chip [1]
        ldq	$9, PROCESSORSTATE_ASRR9($14)	#  [1]
        ldq	$10, PROCESSORSTATE_ASRR10($14)	#  [1]
        ldq	$11, PROCESSORSTATE_ASRR11($14)	#  [1]
        ldq	$12, PROCESSORSTATE_ASRR12($14)	#  [1]
        ldq	$13, PROCESSORSTATE_ASRR13($14)	#  [1]
        ldq	$15, PROCESSORSTATE_ASRR15($14)	#  [1]
        ldq	$26, PROCESSORSTATE_ASRR26($14)	#  [1]
        ldq	$27, PROCESSORSTATE_ASRR27($14)	#  [1]
        ldq	$29, PROCESSORSTATE_ASRR29($14)	#  [1]
        ldq	$30, PROCESSORSTATE_ASRR30($14)	#  [1]
        ldq	$14, PROCESSORSTATE_ASRR14($14)	#  [1]
        ret	$31, ($26), 1	# Home [1]
.end iOutOfLine


/* End of file automatically generated from ../alpha-emulator/ihalt.as */
