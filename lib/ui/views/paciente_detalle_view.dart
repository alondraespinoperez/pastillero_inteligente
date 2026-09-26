import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:pastillero_inteligente/models/medicamento_model.dart';
import 'package:pastillero_inteligente/models/paciente_model.dart';
import 'package:pastillero_inteligente/providers/paciente_provider.dart';
import 'package:pastillero_inteligente/theme/app_theme.dart';
import 'package:pastillero_inteligente/ui/widgets/app_bar_custom.dart';
import 'package:pastillero_inteligente/ui/widgets/medicamento_form.dart';
import 'package:pastillero_inteligente/ui/widgets/sidebar.dart';

class PacienteDetalleView extends StatelessWidget {
  final String pacienteId;

  const PacienteDetalleView({super.key, required this.pacienteId});

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<PacienteProvider>();
    final PacienteModel paciente = prov.pacientes.firstWhere(
      (p) => p.id == pacienteId,
      orElse: () => PacienteModel(
        id: '',
        nombre: 'Paciente no encontrado',
        edad: 0,
        telefono: '',
        diagnostico: '',
        idPastillero: '',
      ),
    );

    return Scaffold(
      appBar: AppBarCustom(titulo: paciente.nombre),
      drawer: const Sidebar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _infoCard(context, paciente),
            const SizedBox(height: 20),
            _contactoEmergencia(paciente),
            const SizedBox(height: 24),
            _encabezadoTratamientos(context, paciente),
            const SizedBox(height: 12),
            if (paciente.listaMedicamentos.isEmpty)
              _estadoVacio(context, paciente)
            else
              ...paciente.listaMedicamentos
                  .map((m) => _medicamentoTile(context, paciente, m)),
          ],
        ),
      ),
    );
  }

  // ─── Contacto de emergencia ────────────────────────────────
  Widget _contactoEmergencia(PacienteModel p) {
    final tieneContacto = p.contactoNombre.isNotEmpty ||
        p.contactoTelefono.isNotEmpty ||
        p.contactoParentesco.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 4,
              height: 18,
              decoration: BoxDecoration(
                color: AppColors.alert,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 10),
            const Icon(Icons.emergency_outlined,
                size: 18, color: AppColors.alert),
            const SizedBox(width: 8),
            const Text(
              'Contacto de Emergencia',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.alert.withValues(alpha: 0.25),
              width: 1.5,
            ),
          ),
          child: tieneContacto
              ? Column(
                  children: [
                    _infoRow(Icons.person_outline, 'Nombre',
                        p.contactoNombre),
                    const Divider(height: 22),
                    _infoRow(Icons.phone_in_talk_outlined, 'Telefono',
                        p.contactoTelefono),
                    const Divider(height: 22),
                    _infoRow(Icons.family_restroom_outlined,
                        'Parentesco', p.contactoParentesco),
                  ],
                )
              : Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 18,
                      color: AppColors.textSecondary.withValues(alpha: 0.6),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'Sin contacto de emergencia registrado',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
        ),
      ],
    );
  }

  // ─── Encabezado de tratamientos ───────────────────────────
  Widget _encabezadoTratamientos(
      BuildContext context, PacienteModel paciente) {
    final total = paciente.listaMedicamentos.length;
    final completados =
        paciente.listaMedicamentos.where((m) => m.estaCompletado).length;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 4,
                  height: 18,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 10),
                const Icon(Icons.medication_outlined,
                    size: 18, color: AppColors.primaryDark),
                const SizedBox(width: 8),
                const Text(
                  'Tratamientos',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.only(left: 32),
              child: Text(
                '$completados de $total completados',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ],
        ),
        TextButton.icon(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.white,
              shape: const RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(20)),
              ),
              builder: (_) => MedicamentoForm(pacienteId: paciente.id),
            );
          },
          icon: const Icon(Icons.add, color: AppColors.primary),
          label: const Text(
            'Agregar',
            style: TextStyle(color: AppColors.primary),
          ),
        ),
      ],
    );
  }

  // ─── Estado vacío de medicamentos ─────────────────────────
  Widget _estadoVacio(BuildContext context, PacienteModel paciente) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Icon(
            Icons.medication_outlined,
            size: 60,
            color: AppColors.textSecondary.withValues(alpha: 0.4),
          ),
          const SizedBox(height: 12),
          const Text(
            'Sin medicamentos prescritos',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Agrega el primer tratamiento para este paciente',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  // ─── Info del paciente ────────────────────────────────────
  Widget _infoCard(BuildContext context, PacienteModel p) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor:
                    AppColors.primary.withValues(alpha: 0.15),
                child: Text(
                  p.nombre.isNotEmpty ? p.nombre[0].toUpperCase() : '?',
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      p.nombre,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${p.edad} años · ${p.idPastillero}',
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: 'Editar',
                icon: const Icon(Icons.edit_outlined,
                    color: AppColors.primary),
                onPressed: () =>
                    context.go('/paciente/editar/${p.id}'),
              ),
            ],
          ),
          const Divider(height: 28),
          _infoRow(Icons.phone_outlined, 'Telefono', p.telefono),
          const Divider(height: 22),
          _infoRow(Icons.memory_outlined, 'Pastillero', p.idPastillero),
          const Divider(height: 22),
          _infoRow(Icons.notes_outlined, 'Diagnostico', p.diagnostico),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 16, color: AppColors.primaryDark),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value.isEmpty ? '—' : value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ─── Tile de medicamento ──────────────────────────────────
  Widget _medicamentoTile(
      BuildContext context, PacienteModel paciente, MedicamentoModel med) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1.5,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'C',
                    style: TextStyle(
                      fontSize: 10,
                      color: AppColors.primaryDark,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '${med.numeroCompartimento}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryDark,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    med.nombre,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${med.dosis} · ${med.frecuencia}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time,
                        size: 14,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        med.horaToma,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryDark,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              children: [
                IconButton(
                  onPressed: () {
                    context
                        .read<PacienteProvider>()
                        .toggleCompletado(paciente.id, med.id);
                  },
                  icon: Icon(
                    med.estaCompletado
                        ? Icons.check_circle
                        : Icons.schedule_outlined,
                    color: med.estaCompletado
                        ? AppColors.primary
                        : AppColors.alert,
                    size: 24,
                  ),
                ),
                IconButton(
                  onPressed: () =>
                      _confirmarEliminarMedicamento(context, paciente, med),
                  icon: const Icon(
                    Icons.delete_outline,
                    color: AppColors.alert,
                    size: 22,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ─── Confirmar eliminar medicamento ───────────────────────
  void _confirmarEliminarMedicamento(
      BuildContext context, PacienteModel paciente, MedicamentoModel med) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text('Eliminar Medicamento'),
        content: Text('¿Eliminar "${med.nombre}" de ${paciente.nombre}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.alert,
              minimumSize: const Size(100, 40),
            ),
            onPressed: () async {
              Navigator.pop(ctx);
              final ok = await context
                  .read<PacienteProvider>()
                  .eliminarMedicamento(paciente.id, med.id);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(ok
                        ? 'Medicamento eliminado'
                        : 'Error al eliminar'),
                    backgroundColor:
                        ok ? AppColors.primary : AppColors.alert,
                  ),
                );
              }
            },
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }
}