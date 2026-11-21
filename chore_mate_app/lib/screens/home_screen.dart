import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:confetti/confetti.dart';
import 'package:chore_mate_app/providers/task_provider.dart';
import 'package:chore_mate_app/models/task_model.dart';
import 'package:flutter_animate/flutter_animate.dart';



class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    // متحكم احتفالية القصاصات الملونة عند إنجاز المهام
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 2));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);

    return Stack(
      children: [
        Scaffold(
          backgroundColor: const Color(0xFF0F172A), // خلفية داكنة عصرية (Dark Mode)
          appBar: AppBar(
            title: const Text('✨ ChoreMate | رفيق المنزل الذكي'),
            centerTitle: true,
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.white,
            elevation: 0,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // كارت النقاط مع تأثير بصري وتدرج لوني فخم
                _buildStunningHeader(taskProvider.totalPoints)
                    .animate()
                    .fadeIn(duration: 600.ms)
                    .slideY(begin: -0.2, end: 0),
                
                const SizedBox(height: 24),
                
                const Text(
                  '🔥 مهام المنزل النشطة',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ).animate().fadeIn(delay: 200.ms),
                
                const SizedBox(height: 12),
                
                // قائمة المهام بتصميم تفاعلي
                Expanded(
                  child: taskProvider.tasks.isEmpty
                      ? _buildEmptyState()
                      : ListView.builder(
                          itemCount: taskProvider.tasks.length,
                          itemBuilder: (context, index) {
                            final task = taskProvider.tasks[index];
                            return _buildInteractiveTaskCard(
                                context, task, taskProvider);
                          },
                        ),
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => _showAddChoreBottomSheet(context),
            backgroundColor: const Color(0xFF6366F1),
            icon: const Icon(Icons.add_task, color: Colors.white),
            label: const Text('إضافة مهمة جديدة',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ).animate().scale(delay: 400.ms, duration: 400.ms),
        ),
        
        // طبقة احتفال القصاصات (Confetti Overlay)
        Align(
          alignment: Alignment.topCenter,
          child: ConfettiWidget(
            confettiController: _confettiController,
            blastDirectionality: BlastDirectionality.explosive,
            shouldLoop: false,
            colors: const [Colors.green, Colors.blue, Colors.pink, Colors.orange, Colors.purple],
          ),
        ),
      ],
    );
  }

  // رأس التطبيق الفخم مع النقاط
  Widget _buildStunningHeader(int totalPoints) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4F46E5), Color(0xFF7C3AED), Color(0xFFEC4899)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4F46E5).withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'لوحة صدارة العائلة 🏆',
                style: TextStyle(color: Colors.white70, fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              Text(
                '$totalPoints نقطة جماعية',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const CircleAvatar(
            radius: 30,
            backgroundColor: Colors.white24,
            child: Icon(Icons.military_tech, color: Colors.amber, size: 36),
          ),
        ],
      ),
    );
  }

  // بطاقة مهمة تفاعلية مع حركات سلسة
  Widget _buildInteractiveTaskCard(
      BuildContext context, Task task, TaskProvider provider) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: task.isCompleted ? Colors.green.withOpacity(0.5) : Colors.white10,
          width: 1.5,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Transform.scale(
          scale: 1.2,
          child: Checkbox(
            value: task.isCompleted,
            activeColor: Colors.green,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
            onChanged: (_) {
              provider.toggleTaskStatus(task.id);
              if (!task.isCompleted) {
                // تفعيل احتفالية النجاح عند انهاء المهمة!
                _confettiController.play();
              }
            },
          ),
        ),
        title: Text(
          task.title,
          style: TextStyle(
            color: task.isCompleted ? Colors.white54 : Colors.white,
            fontSize: 16,
            decoration: task.isCompleted ? TextDecoration.lineThrough : null,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Row(
            children: [
              const Icon(Icons.person_outline, size: 16, color: Colors.white60),
              const SizedBox(width: 4),
              Text(task.assignedTo, style: const TextStyle(color: Colors.white60)),
            ],
          ),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.amber.withOpacity(0.15),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            '+${task.points} 🪙',
            style: const TextStyle(
              color: Colors.amberAccent,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    ).animate().fadeIn().slideX();
  }

  // شكل الشاشة عند خلو المهام
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.task_alt, size: 80, color: Colors.white24),
          const SizedBox(height: 16),
          const Text(
            'رائع! لا توجد مهام معلقة اليوم 🎉',
            style: TextStyle(color: Colors.white60, fontSize: 16),
          ),
        ],
      ),
    );
  }

  // نافذة إضافة المهمة بتصميم منبثق فخم
  void _showAddChoreBottomSheet(BuildContext context) {
    final titleController = TextEditingController();
    final personController = TextEditingController();
    final pointsController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1E293B),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          top: 24,
          left: 24,
          right: 24,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'إضافة مهمة منزلية جديدة 📝',
              style: TextStyle(
                  color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: titleController,
              style: const TextStyle(color: Colors.white),
              decoration: _inputDecoration('عنوان المهمة (مثال: تنظيف المطبخ)'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: personController,
              style: const TextStyle(color: Colors.white),
              decoration: _inputDecoration('اسم الشخص المسؤول'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: pointsController,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
              decoration: _inputDecoration('النقاط (مثال: 50)'),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6366F1),
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                if (titleController.text.isNotEmpty &&
                    personController.text.isNotEmpty) {
                  final newTask = Task(
                    id: DateTime.now().toString(),
                    title: titleController.text,
                    assignedTo: personController.text,
                    dueDate: DateTime.now(),
                    points: int.tryParse(pointsController.text) ?? 10,
                  );
                  Provider.of<TaskProvider>(context, listen: false)
                      .addTask(newTask);
                  Navigator.pop(ctx);
                }
              },
              child: const Text('حفظ المهمة',
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white60),
      filled: true,
      fillColor: const Color(0xFF0F172A),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }
}