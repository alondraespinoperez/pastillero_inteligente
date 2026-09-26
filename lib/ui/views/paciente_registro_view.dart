import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:pastillero_inteligente/models/paciente_model.dart';
import 'package:pastillero_inteligente/providers/paciente_provider.dart';
import 'package:pastillero_inteligente/theme/app_theme.dart';
import 'package:pastillero_inteligente/ui/widgets/app_bar_custom.dart';
import 'package:pastillero_inteligente/ui/widgets/sidebar.dart';
import 'package:pastillero_inteligente/utils/validators.dart';

class PacienteRegistroView extends StatefulWidget {
  final String? pacienteId;

  const PacienteRegistroView({super.key, this.pacienteId});

  @override
  State<PacienteRegistroView> createState() => _PacienteRegistroViewState();
}

class _PacienteRegistroViewState extends State<PacienteRegistroView> {
  final _formKey = GlobalKey<FormState>();
  final _nombreCtrl = TextEditingController();
  final _edadCtrl = TextEditingController();
  final _telefonoCtrl = TextEditingController();
  final _diagnosticoCtrl = TextEditingController();
  final _idPastilleroCtrl = TextEditingController();

  // Contacto de emergencia
  final _contactoNombreCtrl = TextEditingController();
  final _contactoTelefonoCtrl = TextEditingController();
  final _contactoParentescoCtrl = TextEditingController();

  PacienteModel? _original;

  bool get _esEdicion => widget.pacienteId != null;

  @override
  void initState() {
    super.initState();
    if (_esEdicion) {
      final prov = context.read<PacienteProvider>();
      _original = prov.pacientes.firstWhere(
        (p) => p.id == widget.pacienteId,
        orElse: () => PacienteModel(
          id: '',
          nombre: '',
          edad: 0,
          telefono: '',
          diagnostico: '',
          idPastillero: '',
        ),
      );
      _nombreCtrl.text = _original!.nombre;
      _edadCtrl.text = _original!.edad.toString();
      _telefonoCtrl.text = _original!.telefono;
      _diagnosticoCtrl.text = _original!.diagnostico;
      _idPastilleroCtrl.text = _original!.idPastillero;
      _contactoNombreCtrl.text = _original!.contactoNombre;
      _contactoTelefonoCtrl.text = _original!.contactoTelefono;
      _contactoParentescoCtrl.text = _original!.contactoParentesco;
    }
  }

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _edadCtrl.dispose();
    _telefonoCtrl.dispose();
    _diagnosticoCtrl.dispose();
    _idPastilleroCtrl.dispose();
    _contactoNombreCtrl.dispose();
    _contactoTelefonoCtrl.dispose();
    _contactoParentescoCtrl.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;

    final prov = context.read<PacienteProvider>();
    final idPastillero = _idPastilleroCtrl.text.trim().toUpperCase();

    if (prov.idPastilleroExiste(idPastillero,
        excluirId: widget.pacienteId)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'El ID $idPastillero ya esta asignado a otro paciente'),
          backgroundColor: AppColors.alert,
        ),
      );
      return;
    }

    final data = {
      'nombre': _nombreCtrl.text.trim(),
      'edad': int.parse(_edadCtrl.text.trim()),
      'telefono': _telefonoCtrl.text.trim(),
      'diagnostico': _diagnosticoCtrl.text.trim(),
      'id_pastillero': idPastillero,
      'contacto_nombre': _contactoNombreCtrl.text.trim(),
      'contacto_telefono': _contactoTelefonoCtrl.text.trim(),
      'contacto_parentesco': _contactoParentescoCtrl.text.trim(),
    };

    final ok = _esEdicion
        ? await prov.actualizarPaciente(widget.pacienteId!, data)
        : await prov.crearPaciente(data);

    if (!mounted) return;

    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              _esEdicion ? 'Paciente actualizado' : 'Paciente registrado'),
          backgroundColor: AppColors.primary,
        ),
      );
      context.go('/dashboard');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(prov.errorMessage ?? 'Error al guardar'),
          backgroundColor: AppColors.alert,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<PacienteProvider>();

    return Scaffold(
      appBar: AppBarCustom(
        titulo: _esEdicion ? 'Editar Paciente' : 'Nuevo Paciente',
      ),
      drawer: const Sidebar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _header(),
              const SizedBox(height: 24),

              // ─── Datos personales ─────────────────────────
              _seccionTitulo(
                icono: Icons.person_outline,
                titulo: 'Datos Personales',
              ),
              const SizedBox(height: 12),
              _card([
                _campo(
                  controller: _nombreCtrl,
                  label: 'Nombre completo',
                  icon: Icons.badge_outlined,
                  validator: (v) =>
                      Validators.requerido(v, campo: 'Nombre'),
                ),
                _separador(),
                _campo(
                  controller: _edadCtrl,
                  label: 'Edad',
                  icon: Icons.cake_outlined,
                  keyboard: TextInputType.number,
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Edad requerida';
                    final n = int.tryParse(v);
                    if (n == null || n <= 0 || n > 120) {
                      return 'Edad invalida';
                    }
                    return null;
                  },
                ),
                _separador(),
                _campo(
                  controller: _telefonoCtrl,
                  label: 'Telefono',
                  icon: Icons.phone_outlined,
                  keyboard: TextInputType.phone,
                  validator: (v) =>
                      Validators.requerido(v, campo: 'Telefono'),
                ),
              ]),

              const SizedBox(height: 24),

              // ─── Información médica ───────────────────────
              _seccionTitulo(
                icono: Icons.medical_information_outlined,
                titulo: 'Informacion Medica',
              ),
              const SizedBox(height: 12),
              _card([
                _campo(
                  controller: _diagnosticoCtrl,
                  label: 'Diagnostico / Notas medicas',
                  icon: Icons.notes_outlined,
                  maxLines: 4,
                  validator: (v) =>
                      Validators.requerido(v, campo: 'Diagnostico'),
                ),
              ]),

              const SizedBox(height: 24),

              // ─── Contacto de emergencia ───────────────────
              _seccionTitulo(
                icono: Icons.emergency_outlined,
                titulo: 'Contacto de Emergencia',
              ),
              const SizedBox(height: 12),
              _card([
                _campo(
                  controller: _contactoNombreCtrl,
                  label: 'Nombre del contacto',
                  icon: Icons.person_outline,
                  validator: (v) => Validators.requerido(v,
                      campo: 'Nombre del contacto'),
                ),
                _separador(),
                _campo(
                  controller: _contactoTelefonoCtrl,
                  label: 'Telefono de emergencia',
                  icon: Icons.phone_in_talk_outlined,
                  keyboard: TextInputType.phone,
                  validator: (v) => Validators.requerido(v,
                      campo: 'Telefono de emergencia'),
                ),
                _separador(),
                _campo(
                  controller: _contactoParentescoCtrl,
                  label: 'Parentesco',
                  icon: Icons.family_restroom_outlined,
                  hint: 'Ej: Madre, Hijo, Esposo',
                  validator: (v) => Validators.requerido(v,
                      campo: 'Parentesco'),
                ),
              ]),

              const SizedBox(height: 24),

              // ─── Pastillero ───────────────────────────────
              _seccionTitulo(
                icono: Icons.memory_outlined,
                titulo: 'Pastillero Robotico',
              ),
              const SizedBox(height: 12),
              _card([
                _campo(
                  controller: _idPastilleroCtrl,
                  label: 'ID del pastillero',
                  icon: Icons.qr_code_2_outlined,
                  hint: 'Ej: PILL-001',
                  mayusculas: true,
                  validator: (v) =>
                      Validators.requerido(v, campo: 'ID del pastillero'),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline,
                          size: 16, color: AppColors.primaryDark),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'El ID debe coincidir con la etiqueta fisica del pastillero asignado.',
                          style: TextStyle(
                            fontSize: 11.5,
                            color: AppColors.primaryDark,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ]),

              const SizedBox(height: 32),

              // ─── Botones ──────────────────────────────────
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: prov.isLoading ? null : _guardar,
                  icon: prov.isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Icon(_esEdicion
                          ? Icons.save_outlined
                          : Icons.person_add_alt_1),
                  label: Text(
                    _esEdicion
                        ? 'Actualizar Paciente'
                        : 'Guardar Paciente',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => context.go('/dashboard'),
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Cancelar'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.textSecondary,
                    minimumSize: const Size(double.infinity, 52),
                    side: BorderSide(color: Colors.grey.shade300),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _header() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.30),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.25),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              _esEdicion ? Icons.edit_outlined : Icons.person_add_alt_1,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _esEdicion
                      ? 'Actualizar datos'
                      : 'Registrar nuevo paciente',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _esEdicion
                      ? 'Modifica la informacion necesaria'
                      : 'Completa los campos para asignar un pastillero',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.white70,
                    height: 1.4,
                  ),
                ),
              ],
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

  Widget _card(List<Widget> children) {
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
        children: children,
      ),
    );
  }

  Widget _separador() => const SizedBox(height: 16);

  Widget _campo({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? hint,
    int maxLines = 1,
    bool mayusculas = false,
    TextInputType keyboard = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboard,
      maxLines: maxLines,
      textCapitalization: mayusculas
          ? TextCapitalization.characters
          : TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: AppColors.primary),
        alignLabelWithHint: maxLines > 1,
      ),
      validator: validator,
    );
  }
}