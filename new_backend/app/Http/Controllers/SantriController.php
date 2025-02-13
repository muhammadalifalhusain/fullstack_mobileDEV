<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class SantriController extends Controller
{
    public function searchSantri(Request $request)
    {
        // Ambil nama dan kelas dari request
        $nama = $request->input('nama');
        $kelas = $request->input('kelas');

        // Cari santri berdasarkan nama dan kelas yang sesuai
        $santri = DB::table('santri_detail')
            ->where('nama', $nama)
            ->where('kelas', $kelas)
            ->first();

        // Jika santri tidak ditemukan atau kelas tidak cocok
        if (!$santri) {
            return response()->json([
                'success' => false,
                'message' => 'Santri dengan nama dan kelas tersebut tidak ditemukan'
            ], 404);
        }

        // Ambil data kelas dari ref_kelas berdasarkan input kelas yang diberikan user
        $kelasData = DB::table('ref_kelas')
            ->where('code', $kelas)
            ->first();

        // Jika kelas tidak ditemukan atau tidak memiliki employee_id
        if (!$kelasData || !$kelasData->employee_id) {
            return response()->json([
                'success' => false,
                'message' => 'Data kelas tidak valid atau tidak memiliki employee'
            ], 404);
        }

        // Ambil data employee berdasarkan employee_id dari ref_kelas
        $employee = DB::table('employee_new')
            ->where('id', $kelasData->employee_id)
            ->first();

        // Jika employee tidak ditemukan
        if (!$employee) {
            return response()->json([
                'success' => false,
                'message' => 'Data employee tidak ditemukan'
            ], 404);
        }

        // Gabungkan data santri, kelas, dan employee
        return response()->json([
            'success' => true,
            'data' => [
                'id' => $santri->id,
                'nama' => $santri->nama,
                'kelas' => $kelasData->name,
                'employee' => [
                    'id' => $employee->id,
                    'nama' => $employee->nama,
                    'photo' => $employee->photo,
                ]
            ]
        ]);
    }
}
