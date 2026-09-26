import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:pastillero_inteligente/providers/auth_provider.dart';
import 'package:pastillero_inteligente/providers/paciente_provider.dart';
import 'package:pastillero_inteligente/theme/app_theme.dart';
import 'package:pastillero_inteligente/ui/widgets/app_bar_custom.dart';
import 'package:pastillero_inteligente/ui/widgets/sidebar.dart';
import 'package:pastillero_inteligente/utils/dialogs.dart';

class PerfilView extends StatelessWidget {
  const PerfilView({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final pacientes = context.watch<PacienteProvider>();

    final totalPacientes = pacientes.pacientes.length;
    final totalMedicamentos = pacientes.pacientes
        .fold<int>(0, (sum, p) => sum + p.listaMedicamentos.length);

    return Scaffold(
      appBar: const AppBarCustom(titulo: 'Mi Perfil'),
      drawer: const Sidebar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
        child: Column(
          children: [
            _header(auth),
            const SizedBox(height: 24),
            _statsRow(totalPacientes, totalMedicamentos),
            const SizedBox(height: 24),
            _seccionTitulo(
              icono: Icons.badge_outlined,
              titulo: 'Informacion personal',
            ),
            const SizedBox(height: 12),
            _infoCard(auth),
            const SizedBox(height: 24),
            _seccionTitulo(
              icono: Icons.settings_outlined,
              titulo: 'Cuenta',
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _abrirEdicion(context, auth),
                icon: const Icon(Icons.edit_outlined),
                label: const Text('Editar Perfil'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: const BorderSide(color: AppColors.primary),
                  minimumSize: const Size(double.infinity, 52),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => mostrarDialogoLogout(context),
                icon: const Icon(Icons.logout),
                label: const Text('Cerrar Sesion'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.alert,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _header(AuthProvider auth) {
    return Column(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.primary, AppColors.primaryDark],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.35),
                blurRadius: 18,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Center(
            child: Text(
              (auth.nombreMedico ?? 'D').substring(0, 1).toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          auth.nombreMedico ?? 'Doctor',
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColors.secondary,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.medical_services_outlined,
                  size: 13, color: AppColors.primaryDark),
              const SizedBox(width: 5),
              Text(
                auth.especialidad ?? 'Medico General',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryDark,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _statsRow(int pacientes, int medicamentos) {
    return Row(
      children: [
        Expanded(
          child: _statCard(
            icon: Icons.people_alt_outlined,
            valor: '$pacientes',
            label: 'Pacientes',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _statCard(
            icon: Icons.medication_outlined,
            valor: '$medicamentos',
            label: 'Medicamentos',
          ),
        ),
      ],
    );
  }

  Widget _statCard({
    required IconData icon,
    required String valor,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
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
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.primaryDark, size: 22),
          ),
          const SizedBox(height: 10),
          Text(
            valor,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
              height: 1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _seccionTitulo({
    required IconData icono,
    required String titulo,
  }) {
    return Row(
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
        Icon(icono, size: 18, color: AppColors.primaryDark),
        const SizedBox(width: 8),
        Text(
          titulo,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _infoCard(AuthProvider auth) {
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
        children: [
          _infoRow(Icons.person_outline, 'Nombre',
              auth.nombreMedico ?? 'Doctor'),
          const Divider(height: 22),
          _infoRow(Icons.medical_services_outlined, 'Especialidad',
              auth.especialidad ?? 'Medicina General'),
          const Divider(height: 22),
          _infoRow(Icons.badge_outlined, 'Cedula',
              auth.cedula ?? 'Por definir'),
          const Divider(height: 22),
          _infoRow(Icons.email_outlined, 'Correo',
              auth.correo ?? 'Por definir'),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Row(
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
                value,
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

  // ─── Modal de edición CENTRADO ─────────────────────────────
  void _abrirEdicion(BuildContext context, AuthProvider auth) {
    final nombreCtrl =
        TextEditingController(text: auth.nombreMedico ?? '');
    final espCtrl =
        TextEditingController(text: auth.especialidad ?? '');
    final cedCtrl = TextEditingController(text: auth.cedula ?? '');
    final correoCtrl = TextEditingController(text: auth.correo ?? '');
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black54,
      useSafeArea: false,
      builder: (ctx) {
        final size = MediaQuery.of(ctx).size;
        final isWide = size.width > 500;
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 24,
          ),
          child: SizedBox(
            width: isWide ? 420 : size.width - 32,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Título
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.primary
                                  .withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.edit_outlined,
                              color: AppColors.primaryDark,
                              size: 18,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Text(
                              'Editar Perfil',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: AppColors.secondary,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close,
                                color: AppColors.textSecondary),
                            onPressed: () => Navigator.pop(ctx),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      const Divider(height: 1),
                      const SizedBox(height: 18),

                      TextFormField(
                        controller: nombreCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Nombre completo',
                          prefixIcon: Icon(Icons.person_outline),
                        ),
                        validator: (v) =>
                            v == null || v.isEmpty ? 'Requerido' : null,
                      ),
                      const SizedBox(height: 14),
                      TextFormField(
                        controller: espCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Especialidad',
                          prefixIcon:
                              Icon(Icons.medical_services_outlined),
                        ),
                        validator: (v) =>
                            v == null || v.isEmpty ? 'Requerido' : null,
                      ),
                      const SizedBox(height: 14),
                      TextFormField(
                        controller: cedCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Cedula',
                          prefixIcon: Icon(Icons.badge_outlined),
                        ),
                      ),
                      const SizedBox(height: 14),
                      TextFormField(
                        controller: correoCtrl,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: 'Correo electronico',
                          prefixIcon: Icon(Icons.email_outlined),
                        ),
                      ),
                      const SizedBox(height: 22),

                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => Navigator.pop(ctx),
                              style: OutlinedButton.styleFrom(
                                foregroundColor:
                                    AppColors.textSecondary,
                                side: BorderSide(
                                    color: Colors.grey.shade300),
                                minimumSize:
                                    const Size(double.infinity, 48),
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(14),
                                ),
                              ),
                              child: const Text('Cancelar'),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            flex: 2,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                if (!formKey.currentState!
                                    .validate()) {
                                  return;
                                }
                                context
                                    .read<AuthProvider>()
                                    .actualizarPerfilLocal(
                                      nombre: nombreCtrl.text.trim(),
                                      especialidad: espCtrl.text.trim(),
                                      cedula: cedCtrl.text.trim(),
                                      correo: correoCtrl.text.trim(),
                                    );
                                Navigator.pop(ctx);
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(
                                  const SnackBar(
                                    content:
                                        Text('Perfil actualizado'),
                                    backgroundColor:
                                        AppColors.primary,
                                  ),
                                );
                              },
                              icon: const Icon(Icons.save_outlined,
                                  size: 18),
                              label: const Text('Guardar'),
                              style: ElevatedButton.styleFrom(
                                minimumSize:
                                    const Size(double.infinity, 48),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}