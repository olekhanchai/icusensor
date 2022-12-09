/*
 *  /**
 *  * Copyright (C) 2017  Grbl Controller Contributors
 *  *
 *  * This program is free software; you can redistribute it and/or modify
 *  * it under the terms of the GNU General Public License as published by
 *  * the Free Software Foundation; either version 2 of the License, or
 *  * (at your option) any later version.
 *  *
 *  * This program is distributed in the hope that it will be useful,
 *  * but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  * GNU General Public License for more details.
 *  *
 *  * You should have received a copy of the GNU General Public License along
 *  * with this program; if not, write to the Free Software Foundation, Inc.,
 *  * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
 *  * <http://www.gnu.org/licenses/>
 *
 */

package com.main.icusensor.model;

public enum Overrides {
    CMD_FEED_OVR_RESET,             // 0x90
    CMD_FEED_OVR_COARSE_PLUS,       // 0x91
    CMD_FEED_OVR_COARSE_MINUS,      // 0x92
    CMD_FEED_OVR_FINE_PLUS ,        // 0x93
    CMD_FEED_OVR_FINE_MINUS ,       // 0x94
    CMD_RAPID_OVR_RESET,            // 0x95
    CMD_RAPID_OVR_MEDIUM,           // 0x96
    CMD_RAPID_OVR_LOW,              // 0x97
    CMD_SPINDLE_OVR_RESET,          // 0x99
    CMD_SPINDLE_OVR_COARSE_PLUS,    // 0x9A
    CMD_SPINDLE_OVR_COARSE_MINUS,   // 0x9B
    CMD_SPINDLE_OVR_FINE_PLUS,      // 0x9C
    CMD_SPINDLE_OVR_FINE_MINUS,     // 0x9D
    CMD_TOGGLE_SPINDLE,             // 0x9E
    CMD_TOGGLE_FLOOD_COOLANT,       // 0xA0
    CMD_TOGGLE_MIST_COOLANT,        // 0xA1
}

